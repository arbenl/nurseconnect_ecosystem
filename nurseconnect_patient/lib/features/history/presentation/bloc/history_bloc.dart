import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurseconnect_patient/features/history/domain/repositories/history_repository.dart';

// lib/features/history/presentation/bloc/history_bloc.dart
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc({required this.historyRepository}) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    final result = await historyRepository.getServiceHistory(event.userId);
    result.fold(
      (failure) => emit(HistoryError(failure.message ?? 'Failed to load history')),
      (history) => emit(HistoryLoaded(history)),
    );
  }
}
