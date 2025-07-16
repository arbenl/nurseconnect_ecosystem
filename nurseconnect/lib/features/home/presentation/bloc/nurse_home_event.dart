part of 'nurse_home_bloc.dart';

abstract class NurseHomeEvent extends Equatable {
  const NurseHomeEvent();
  @override
  List<Object> get props => [];
}

class LoadNurseData extends NurseHomeEvent {
  const LoadNurseData();
}

class ToggleAvailabilityRequested extends NurseHomeEvent {
  const ToggleAvailabilityRequested({required this.desiredAvailability});

  final bool desiredAvailability;

  @override
  List<Object> get props => [desiredAvailability];
}

class SubscribeToOffers extends NurseHomeEvent {
  const SubscribeToOffers();
}

class UnsubscribeFromOffers extends NurseHomeEvent {
  const UnsubscribeFromOffers();
}

class LogoutRequested extends NurseHomeEvent {
  const LogoutRequested();
}

class OfferAccepted extends NurseHomeEvent {
  const OfferAccepted({required this.requestId});

  final String requestId;

  @override
  List<Object> get props => [requestId];
}

class OfferRejected extends NurseHomeEvent {
  const OfferRejected({required this.requestId});

  final String requestId;

  @override
  List<Object> get props => [requestId];
}
