import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nurseconnect_patient/features/auth/domain/repositories/user_repository.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import '../../domain/repositories/service_request_repository.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final ServiceRequestRepository serviceRequestRepository;
  final FirebaseFirestore firestore;

  HomeBloc({
    required this.userRepository,
    required this.serviceRequestRepository,
    required this.firestore,
  }) : super(const HomeInitial()) {
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
    on<_SubscribeToRequest>(_onSubscribeToRequest);
    on<_RequestUpdateReceived>(_onRequestUpdateReceived);
    on<_CancelRequestSubscription>(_onCancelRequestSubscription);
    on<SubmitServiceRequest>(_onSubmitServiceRequest);
  }

  Future<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<HomeState> emit,
  ) async {
    add(_CancelRequestSubscription());
    emit(const HomeLogoutSuccess());
  }

  Future<void> _onSubmitServiceRequest(
      SubmitServiceRequest event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());
    try {
      AppLogger.log("Fetching current user data for service request...", tag: "HomeBloc");
      final userResult = await userRepository.getCurrentUserData();
      late UserData currentUser;
      userResult.fold(
        (failure) {
          AppLogger.error("Error fetching user data: ${failure.message}", tag: "HomeBloc");
          emit(HomeError(message: "Failed to get user data: ${failure.message}"));
          return; // Exit if user data fetch fails
        },
        (user) {
          currentUser = user;
          AppLogger.log("User data fetched: ${currentUser.name}", tag: "HomeBloc");
        },
      );
      if (state is HomeError) return; // If an error was emitted, stop further processing

      final GeoPoint patientLocation = GeoPoint(
        event.currentPosition.latitude,
        event.currentPosition.longitude,
      );

      final result = await serviceRequestRepository.createServiceRequest(
        patientLocation: patientLocation,
        patientData: currentUser,
        serviceDetails: event.service.name, // Use selected service name as details
        paymentMethodId: event.paymentMethodId,
      );

      result.fold(
        (failure) {
          AppLogger.error("Error creating service request: $failure", tag: "HomeBloc");
          emit(const HomeError(message: "Failed to submit request."));
        },
        (requestId) {
          AppLogger.log("Service request created successfully with ID: $requestId", tag: "HomeBloc");
          emit(HomeServiceRequestSuccess(requestId: requestId));
          add(_SubscribeToRequest(requestId));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error("Error during service request submission process", tag: "HomeBloc", error: e, stackTrace: stackTrace);
      emit(HomeError(message: "Failed to submit request: $e"));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(const HomeInitial(
        activeRequest: null,
        requestSubscription: null,
      ));
    }
  }

  Future<void> _onSubscribeToRequest(
    _SubscribeToRequest event,
    Emitter<HomeState> emit,
  ) async {
    await state.requestSubscription?.cancel();

    AppLogger.log("Subscribing to request updates for ID: ${event.requestId}", tag: "HomeBloc");

    final stream = firestore
        .collection('serviceRequests')
        .doc(event.requestId)
        .snapshots();

    final subscription = stream.listen(
      (snapshot) {
        if (snapshot.exists) {
          try {
            final requestData = ServiceRequestData.fromFirestore(snapshot);
            AppLogger.log("Received request update: Status = ${requestData.status.name}", tag: "HomeBloc");
            add(_RequestUpdateReceived(requestData));
          } catch (e, stackTrace) {
            AppLogger.error("Error parsing request snapshot", tag: "HomeBloc", error: e, stackTrace: stackTrace);
            emit(HomeError(message: "Error processing request update: $e"));
          }
        } else {
          AppLogger.log("Request document ${event.requestId} snapshot doesn't exist.", tag: "HomeBloc");
          add(_CancelRequestSubscription());
        }
      },
      onError: (error, stackTrace) {
        AppLogger.error("Error listening to request ${event.requestId}", tag: "HomeBloc", error: error, stackTrace: stackTrace);
        emit(HomeError(message: "Error listening to request status: $error"));
        add(_CancelRequestSubscription());
      },
      onDone: () {
        AppLogger.log("Request stream ${event.requestId} closed.", tag: "HomeBloc");
        if(state.activeRequest?.requestId == event.requestId) {
          add(_CancelRequestSubscription());
        }
      }
    );

    emit(state.copyWith(requestSubscription: subscription, activeRequest: state.activeRequest));
  }

  void _onRequestUpdateReceived(
    _RequestUpdateReceived event,
    Emitter<HomeState> emit,
  ) {
    AppLogger.log("Processing request update in Bloc: Status = ${event.updatedRequestData.status.name}", tag: "HomeBloc");
    emit(state.copyWith(activeRequest: event.updatedRequestData));

    final status = event.updatedRequestData.status;
    if (status == ServiceRequestStatus.completed ||
        status == ServiceRequestStatus.cancelled ||
        status == ServiceRequestStatus.failed) {
      AppLogger.log("Request reached terminal state (${status.name}), cancelling subscription.", tag: "HomeBloc");
      add(_CancelRequestSubscription());
    }
  }

  Future<void> _onCancelRequestSubscription(
    _CancelRequestSubscription event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.log("Cancelling Firestore subscription.", tag: "HomeBloc");
    await state.requestSubscription?.cancel();
    emit(state.copyWith(activeRequest: null, requestSubscription: null));
  }

  @override
  Future<void> close() {
    state.requestSubscription?.cancel();
    return super.close();
  }
}

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override List<Object> get props => [];
}

class LogoutButtonPressed extends HomeEvent {}

class _SubscribeToRequest extends HomeEvent {
  final String requestId;
  const _SubscribeToRequest(this.requestId);
  @override List<Object> get props => [requestId];
}

class _RequestUpdateReceived extends HomeEvent {
  final ServiceRequestData updatedRequestData;
  const _RequestUpdateReceived(this.updatedRequestData);
  @override List<Object> get props => [updatedRequestData];
}

class _CancelRequestSubscription extends HomeEvent {}

class SubmitServiceRequest extends HomeEvent {
  final NursingService service;
  final Position currentPosition;
  final String paymentMethodId;

  const SubmitServiceRequest({
    required this.service,
    required this.currentPosition,
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [service, currentPosition, paymentMethodId];
}

abstract class HomeState extends Equatable {
  final ServiceRequestData? activeRequest;
  final StreamSubscription? requestSubscription;

  const HomeState({this.activeRequest, this.requestSubscription});

  @override
  List<Object?> get props => [activeRequest, requestSubscription];

  HomeState copyWith({
    Object? activeRequest = const _Undefined(),
    Object? requestSubscription = const _Undefined(),
  }) {
    final newActiveRequest = activeRequest is _Undefined ? this.activeRequest : activeRequest as ServiceRequestData?;
    final newSubscription = requestSubscription is _Undefined ? this.requestSubscription : requestSubscription as StreamSubscription?;
    final currentType = runtimeType;

    if (currentType == HomeInitial) {
      return HomeInitial(activeRequest: newActiveRequest, requestSubscription: newSubscription);
    } else if (currentType == HomeLoading) {
      return HomeLoading(
        activeRequest: newActiveRequest,
        requestSubscription: newSubscription,
      );
    } else if (currentType == HomeServiceRequestSuccess) {
      final currentSuccess = this as HomeServiceRequestSuccess;
      return HomeServiceRequestSuccess(
        requestId: currentSuccess.requestId,
        activeRequest: newActiveRequest,
        requestSubscription: newSubscription,
      );
    } else if (currentType == HomeError) {
      final currentError = this as HomeError;
      return HomeError(
        message: currentError.message,
        activeRequest: newActiveRequest,
        requestSubscription: newSubscription,
      );
    } else if (currentType == HomeLogoutSuccess) {
      return HomeLogoutSuccess();
    }
    return HomeInitial(activeRequest: newActiveRequest, requestSubscription: newSubscription);
  }
}

class _Undefined {
  const _Undefined();
}

class HomeInitial extends HomeState {
  const HomeInitial({super.activeRequest, super.requestSubscription});
}

class HomeLoading extends HomeState {
  const HomeLoading({
    super.activeRequest,
    super.requestSubscription,
  });
}

class HomeServiceRequestSuccess extends HomeState {
  final String requestId;
  const HomeServiceRequestSuccess({
    required this.requestId,
    super.activeRequest,
    super.requestSubscription,
  });

  @override
  List<Object?> get props => [requestId, activeRequest, requestSubscription];
}

class HomeLogoutSuccess extends HomeState {
  const HomeLogoutSuccess() : super();
}

class HomeError extends HomeState {
  final String message;
  const HomeError({
    required this.message,
    super.activeRequest,
    super.requestSubscription,
  });
  @override
  List<Object?> get props => [message, activeRequest, requestSubscription];
}
