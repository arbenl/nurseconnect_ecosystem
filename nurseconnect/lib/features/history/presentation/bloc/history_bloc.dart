part 'history_event.dart';
part 'history_state.dart';

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nurseconnect/features/history/domain/repositories/history_repository.dart';

export 'history_event.dart';
export 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc({required this.historyRepository}) : super(HistoryInitial()) {
    on<LoadServiceHistory>(_onLoadServiceHistory);
  }

  Future<void> _onLoadServiceHistory(
      LoadServiceHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final serviceRequestsResult = await historyRepository.getCompletedServiceRequests(event.nurseId);
      serviceRequestsResult.fold(
        (failure) => emit(HistoryError(message: failure.message)),
        (serviceRequests) => emit(HistoryLoaded(serviceRequests: serviceRequests)),
      );
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }
}
