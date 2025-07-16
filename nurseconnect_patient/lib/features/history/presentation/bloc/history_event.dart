// history_event.dart
import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistory extends HistoryEvent {
  final String userId;

  const LoadHistory(this.userId);

  @override
  List<Object> get props => [userId];
}