// history_event.dart
import 'package:equatable/equatable.dart';

// history_state.dart

import 'package:nurseconnect_shared/models/service_request_data.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ServiceRequestData> history;

  const HistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}