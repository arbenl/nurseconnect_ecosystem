part of 'nurse_home_bloc.dart';

abstract class NurseHomeState extends Equatable {
  final NurseProfileData? nurseData;
  final List<ServiceRequestData> activeOffers;

  const NurseHomeState({
    this.nurseData,
    this.activeOffers = const [],
  });

  @override
  List<Object?> get props => [nurseData, activeOffers];
}

class NurseHomeInitial extends NurseHomeState {
  const NurseHomeInitial({
    super.nurseData,
    super.activeOffers,
  });
}

class NurseHomeLoading extends NurseHomeState {
  const NurseHomeLoading({
    super.nurseData,
    super.activeOffers,
  });
}

class NurseHomeLocationUpdating extends NurseHomeState {
  const NurseHomeLocationUpdating({
    super.nurseData,
    super.activeOffers,
  });
}

class NurseHomeLoaded extends NurseHomeState {
  const NurseHomeLoaded({
    required super.nurseData,
    required super.activeOffers,
  });
}

class NurseHomeOfferActionLoading extends NurseHomeState {
  final String processingRequestId;
  const NurseHomeOfferActionLoading({
    required this.processingRequestId,
    required super.nurseData,
    required super.activeOffers,
  });

  @override
  List<Object?> get props => [nurseData, activeOffers, processingRequestId];
}

class NurseHomeOfferActionError extends NurseHomeState {
  final String message;
  final String failedRequestId;
  const NurseHomeOfferActionError({
    required this.message,
    required this.failedRequestId,
    required super.nurseData,
    required super.activeOffers,
  });

  @override
  List<Object?> get props => [message, failedRequestId, nurseData, activeOffers];
}

class NurseHomeError extends NurseHomeState {
  final String message;

  const NurseHomeError({
    required this.message,
    super.nurseData,
    required super.activeOffers,
  });

  @override
  List<Object?> get props => [message, nurseData, activeOffers];
}