import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurseconnect/features/active_service/domain/repositories/active_service_repository.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';

part 'active_service_event.dart';
part 'active_service_state.dart';

export 'active_service_event.dart';
export 'active_service_state.dart';




class ActiveServiceBloc extends Bloc<ActiveServiceEvent, ActiveServiceState> {
  final ActiveServiceRepository activeServiceRepository;
  StreamSubscription<ServiceRequestData>? _serviceRequestSubscription;

  ActiveServiceBloc({required this.activeServiceRepository})
      : super(ActiveServiceInitial()) {
    on<LoadActiveService>(_onLoadActiveService);
    on<ActiveServiceUpdated>(_onActiveServiceUpdated);
    on<CompleteServiceRequested>(_onCompleteServiceRequested);
    on<SubmitRating>(_onSubmitRating);
  }

  Future<void> _onLoadActiveService(
      LoadActiveService event, Emitter<ActiveServiceState> emit) async {
    emit(ActiveServiceLoading());
    _serviceRequestSubscription?.cancel(); // Cancel previous subscription if any
    try {
      _serviceRequestSubscription = activeServiceRepository
          .getServiceRequestStream(event.serviceRequestId)
          .listen(
        (serviceRequestData) {
          add(ActiveServiceUpdated(serviceRequestData: serviceRequestData));
        },
        onError: (error) {
          emit(ActiveServiceError(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ActiveServiceError(message: e.toString()));
    }
  }

  void _onActiveServiceUpdated(
      ActiveServiceUpdated event, Emitter<ActiveServiceState> emit) {
    try {
      emit(ActiveServiceLoaded(serviceRequest: event.serviceRequestData));
    } catch (e) {
      emit(ActiveServiceError(message: 'Failed to parse service request data: ${e.toString()}'));
    }
  }

  Future<void> _onCompleteServiceRequested(
      CompleteServiceRequested event, Emitter<ActiveServiceState> emit) async {
    if (state is! ActiveServiceLoaded) {
      emit(const ActiveServiceCompletionError(message: 'Service not loaded yet.'));
      return;
    }
    final currentState = state as ActiveServiceLoaded;
    emit(ActiveServiceCompleting(serviceRequest: currentState.serviceRequest));
    final result = await activeServiceRepository.completeServiceRequest(event.serviceRequestId);

    result.fold(
      (failure) => emit(const ActiveServiceError(message: 'Failed to complete service.')),
      (_) => emit(ActiveServiceInitial()),
    );
  }

  Future<void> _onSubmitRating(
      SubmitRating event, Emitter<ActiveServiceState> emit) async {
    if (state is! ActiveServiceLoaded) {
      emit(const RatingSubmissionFailure(message: 'Service not loaded yet.'));
      return;
    }
    final currentState = state as ActiveServiceLoaded;
    emit(RatingSubmissionInProgress(serviceRequest: currentState.serviceRequest));
    final result = await activeServiceRepository.submitRating(
        event.serviceRequestId, event.rating, event.comment);

    result.fold(
      (failure) => emit(const RatingSubmissionFailure(message: 'Failed to submit rating.')),
      (_) => emit(RatingSubmissionSuccess()),
    );
  }

  @override
  Future<void> close() {
    _serviceRequestSubscription?.cancel();
    return super.close();
  }
}
