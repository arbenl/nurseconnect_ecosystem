import 'package:nurseconnect_shared/models/service_request_data.dart';
part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ServiceRequestData> serviceRequests;

  const HistoryLoaded({required this.serviceRequests});

  @override
  List<Object> get props => [serviceRequests];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
