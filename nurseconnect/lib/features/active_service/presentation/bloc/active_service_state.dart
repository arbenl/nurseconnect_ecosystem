part of 'active_service_bloc.dart';

abstract class ActiveServiceState extends Equatable {
  const ActiveServiceState();

  @override
  List<Object> get props => [];
}

class ActiveServiceInitial extends ActiveServiceState {}

class ActiveServiceLoading extends ActiveServiceState {}

class ActiveServiceLoaded extends ActiveServiceState {
  final ServiceRequestData serviceRequest;

  const ActiveServiceLoaded({required this.serviceRequest});

  @override
  List<Object> get props => [serviceRequest];
}

class ActiveServiceError extends ActiveServiceState {
  final String message;

  const ActiveServiceError({required this.message});

  @override
  List<Object> get props => [message];
}

class ActiveServiceCompleting extends ActiveServiceState {
  final ServiceRequestData serviceRequest;

  const ActiveServiceCompleting({required this.serviceRequest});

  @override
  List<Object> get props => [serviceRequest];
}

class ActiveServiceCompleted extends ActiveServiceState {}

class ActiveServiceCompletionError extends ActiveServiceState {
  final String message;

  const ActiveServiceCompletionError({required this.message});

  @override
  List<Object> get props => [message];
}

class RatingSubmissionInProgress extends ActiveServiceState {
  final ServiceRequestData serviceRequest;

  const RatingSubmissionInProgress({required this.serviceRequest});

  @override
  List<Object> get props => [serviceRequest];
}


class RatingSubmissionSuccess extends ActiveServiceState {}

class RatingSubmissionFailure extends ActiveServiceState {
  final String message;

  const RatingSubmissionFailure({required this.message});

  @override
  List<Object> get props => [message];
}
