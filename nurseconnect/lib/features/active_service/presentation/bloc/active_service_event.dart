part of 'active_service_bloc.dart';

abstract class ActiveServiceEvent extends Equatable {
  const ActiveServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadActiveService extends ActiveServiceEvent {
  final String serviceRequestId;

  const LoadActiveService({required this.serviceRequestId});

  @override
  List<Object> get props => [serviceRequestId];
}

class ActiveServiceUpdated extends ActiveServiceEvent {
  final ServiceRequestData serviceRequestData;

  const ActiveServiceUpdated({required this.serviceRequestData});

  @override
  List<Object> get props => [serviceRequestData];
}

class CompleteServiceRequested extends ActiveServiceEvent {
  final String serviceRequestId;

  const CompleteServiceRequested({required this.serviceRequestId});

  @override
  List<Object> get props => [serviceRequestId];
}

class SubmitRating extends ActiveServiceEvent {
  final String serviceRequestId;
  final double rating;
  final String comment;

  const SubmitRating({
    required this.serviceRequestId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object> get props => [serviceRequestId, rating, comment];
}
