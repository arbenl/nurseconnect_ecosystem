part 'nurse_home_event.dart';
part 'nurse_home_state.dart';

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire3/geoflutterfire3.dart';
import 'package:nurseconnect/features/nurse_jobs/domain/repositories/nurse_service_request_repository.dart';
import 'package:nurseconnect/features/auth/domain/repositories/nurse_repository.dart';
import 'package:nurseconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurseconnect_shared/models/nurse_profile_data.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';

export 'nurse_home_event.dart';
export 'nurse_home_state.dart';

class NurseHomeBloc extends Bloc<NurseHomeEvent, NurseHomeState> {
  final NurseRepository nurseRepository;
  final FirebaseAuth firebaseAuth;
  final AuthRepository authRepository;
  final FirebaseFunctions firebaseFunctions;
  final NurseServiceRequestRepository nurseServiceRequestRepository;
  final geo = GeoFlutterFire();

  NurseHomeBloc({
    required this.nurseRepository,
    required this.firebaseAuth,
    required this.authRepository,
    required this.firebaseFunctions,
    required this.nurseServiceRequestRepository,
  }) : super(NurseHomeInitial()) {
    on<LoadNurseData>(_onLoadNurseData);
    on<ToggleAvailabilityRequested>(_onToggleAvailabilityRequested);
    on<OfferAccepted>(_onOfferAccepted);
    on<OfferRejected>(_onOfferRejected);
  }

  Future<void> _onLoadNurseData(
      LoadNurseData event, Emitter<NurseHomeState> emit) async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      emit(NurseHomeError(message: "User not logged in.", activeOffers: state.activeOffers));
      return;
    }

    emit(NurseHomeLoading(nurseData: state.nurseData, activeOffers: state.activeOffers));
    try {
      final uid = currentUser.uid;
      final nurseDataResult = await authRepository.getNurseProfile(uid);
      nurseDataResult.fold(
        (failure) => emit(NurseHomeError(message: failure.message, nurseData: state.nurseData, activeOffers: state.activeOffers)),
        (nurseData) => emit(NurseHomeLoaded(nurseData: nurseData, activeOffers: state.activeOffers)),
      );

      await emit.forEach<List<ServiceRequestData>>(
        nurseServiceRequestRepository.getOffersForNurse(uid),
        onData: (offers) {
          final currentState = state;
          if (currentState is NurseHomeLoaded) {
            return NurseHomeLoaded(nurseData: currentState.nurseData!, activeOffers: offers);
          } else if (currentState is NurseHomeLoading) {
            return NurseHomeLoading(nurseData: currentState.nurseData, activeOffers: offers);
          } else if (currentState is NurseHomeLocationUpdating) {
            return NurseHomeLocationUpdating(nurseData: currentState.nurseData!, activeOffers: offers);
          } else if (currentState is NurseHomeError) {
            return NurseHomeError(message: currentState.message, nurseData: currentState.nurseData, activeOffers: offers);
          } else {
            return NurseHomeInitial(activeOffers: offers);
          }
        },
        onError: (error, _) {
          AppLogger.log("Error in offers stream: $error", tag: 'NurseHomeBloc');
          emit(NurseHomeError(message: "Error receiving offers: $error", nurseData: state.nurseData, activeOffers: state.activeOffers));
          return state;
        },
      );
    } catch (e) {
      emit(NurseHomeError(
        message: "Failed to load nurse data: ${e.toString()}",
        nurseData: state.nurseData,
        activeOffers: state.activeOffers,
      ));
    }
  }

  Future<void> _onToggleAvailabilityRequested(
      ToggleAvailabilityRequested event, Emitter<NurseHomeState> emit) async {
    final currentData = state.nurseData;
    final currentUser = firebaseAuth.currentUser;
    final bool becomingAvailable = event.desiredAvailability;

    if (currentUser == null || currentData == null) {
      emit(NurseHomeError(
        message: "Cannot toggle availability: User or data missing.",
        nurseData: state.nurseData,
        activeOffers: state.activeOffers,
      ));
      return;
    }

    if (becomingAvailable) {
      emit(NurseHomeLocationUpdating(
        nurseData: currentData,
        activeOffers: state.activeOffers,
      ));
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) throw Exception('Location services are disabled.');
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) throw Exception('Location permissions are denied.');
        }
        if (permission == LocationPermission.deniedForever) throw Exception('Location permissions are permanently denied.');

                        Position position = await Geolocator.getCurrentPosition();
        GeoFirePoint geoFirePoint = geo.point(latitude: position.latitude, longitude: position.longitude);

        await nurseRepository.updateLocation(
          uid: currentUser.uid,
          location: geoFirePoint.geoPoint,
          geohash: geoFirePoint.hash,
        );
        await nurseRepository.updateAvailability(
          uid: currentUser.uid,
          isAvailable: true,
        );

        emit(NurseHomeLoaded(
          nurseData: currentData.copyWith(isAvailable: true),
          activeOffers: state.activeOffers,
        ));
      } catch (e) {
        emit(NurseHomeError(
          message: "Failed set availability: ${e.toString()}",
          nurseData: currentData.copyWith(isAvailable: false),
          activeOffers: state.activeOffers,
        ));
      }
    } else {
      emit(NurseHomeLoading(
        nurseData: currentData.copyWith(isAvailable: false),
        activeOffers: state.activeOffers,
      ));
      try {
        await nurseRepository.updateAvailability(
          uid: currentUser.uid,
          isAvailable: false,
        );
        emit(NurseHomeLoaded(
          nurseData: currentData.copyWith(isAvailable: false),
          activeOffers: state.activeOffers,
        ));
      } catch (e) {
        emit(NurseHomeError(
          message: "Failed to update availability: ${e.toString()}",
          nurseData: currentData.copyWith(isAvailable: true),
          activeOffers: state.activeOffers,
        ));
      }
    }
  }

  Future<void> _onOfferAccepted(
      OfferAccepted event, Emitter<NurseHomeState> emit) async {
    AppLogger.log("DEBUG: _onOfferAccepted entered for ${event.requestId}", tag: 'NurseHomeBloc');
    if (state.nurseData == null) return;

    emit(NurseHomeOfferActionLoading(
      processingRequestId: event.requestId,
      nurseData: state.nurseData!,
      activeOffers: state.activeOffers,
    ));

    try {
      HttpsCallable callable = firebaseFunctions.httpsCallable('respondToOffer');
      AppLogger.log("Calling respondToOffer: ACCEPT for ${event.requestId}", tag: 'NurseHomeBloc');
      final result = await callable.call<Map<String, dynamic>>({
        'requestId': event.requestId,
        'response': 'accepted',
      });
      AppLogger.log("Cloud function result: ${result.data}", tag: 'NurseHomeBloc');
      emit(NurseHomeLoaded(
        nurseData: state.nurseData!,
        activeOffers: state.activeOffers,
      ));
    } on FirebaseFunctionsException catch (e) {
      AppLogger.log("Error calling function (ACCEPT): ${e.code} - ${e.message}", tag: 'NurseHomeBloc');
      emit(NurseHomeOfferActionError(
        message: "Failed to accept offer: ${e.message} (${e.code})",
        failedRequestId: event.requestId,
        nurseData: state.nurseData!,
        activeOffers: state.activeOffers,
      ));
    } catch (e) {
      AppLogger.log("Generic error accepting offer: $e", tag: 'NurseHomeBloc');
      emit(NurseHomeOfferActionError(
        message: "An unexpected error occurred while accepting.",
        failedRequestId: event.requestId,
        nurseData: state.nurseData!,
        activeOffers: state.activeOffers,
      ));
    }
  }

  Future<void> _onOfferRejected(
      OfferRejected event, Emitter<NurseHomeState> emit) async {
    AppLogger.log("DEBUG: _onOfferRejected entered for ${event.requestId}", tag: 'NurseHomeBloc');
    if (state.nurseData == null) return;

    emit(NurseHomeOfferActionLoading(
      processingRequestId: event.requestId,
      nurseData: state.nurseData!,
      activeOffers: state.activeOffers,
    ));

    try {
      HttpsCallable callable = firebaseFunctions.httpsCallable('respondToOffer');
      AppLogger.log("Calling respondToOffer: REJECT for ${event.requestId}", tag: 'NurseHomeBloc');
      final result = await callable.call<Map<String, dynamic>>({
        'requestId': event.requestId,
        'response': 'rejected',
      });
      AppLogger.log("Cloud function result: ${result.data}", tag: 'NurseHomeBloc');
      emit(NurseHomeLoaded(
        nurseData: state.nurseData!,
        activeOffers: state.activeOffers,
      ));
    } on FirebaseFunctionsException catch (e) {
      AppLogger.log("Error calling function (REJECT): ${e.code} - ${e.message}", tag: 'NurseHomeBloc');
      emit(NurseHomeOfferActionError(
        message: "Failed to reject offer: ${e.message} (${e.code})",
        failedRequestId: event.requestId,
        nurseData: state.nurseData!,
        activeOffers: state.activeOffers,
      ));
    } catch (e) {
      AppLogger.log("Generic error rejecting offer: $e", tag: 'NurseHomeBloc');
      emit(NurseHomeOfferActionError(
        message: "An unexpected error occurred while rejecting.",
        failedRequestId: event.requestId,
        nurseData: state.nurseData!,
        activeOffers: state.activeOffers,
      ));
    }
  }

  @override
  Future<void> close() {
    AppLogger.log("Closing NurseHomeBloc.", tag: "NurseHomeBloc");
    return super.close();
  }
}