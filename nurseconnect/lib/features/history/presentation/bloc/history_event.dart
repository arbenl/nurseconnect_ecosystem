part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadServiceHistory extends HistoryEvent {
  final String nurseId;

  const LoadServiceHistory({required this.nurseId});

  @override
  List<Object> get props => [nurseId];
}
