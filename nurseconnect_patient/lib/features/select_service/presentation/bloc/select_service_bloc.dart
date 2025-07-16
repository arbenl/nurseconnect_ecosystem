import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_patient/features/select_service/domain/repositories/nursing_service_repository.dart';


class SelectServiceBloc extends Bloc<SelectServiceEvent, SelectServiceState> {
  final NursingServiceRepository nursingServiceRepository;

  SelectServiceBloc({required this.nursingServiceRepository}) : super(SelectServiceInitial()) {
    on<LoadServices>(_onLoadServices);
    on<ServiceSelected>(_onServiceSelected);
  }

  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<SelectServiceState> emit,
  ) async {
    emit(SelectServiceLoading());
    final result = await nursingServiceRepository.getNursingServices();
    result.fold(
      (failure) => emit(SelectServiceError(message: failure.message ?? 'Failed to load nursing services')),
      (services) => emit(SelectServiceLoaded(services: services)),
    );
  }

  void _onServiceSelected(
    ServiceSelected event,
    Emitter<SelectServiceState> emit,
  ) {
    emit(ServiceSelectionSuccess(selectedService: event.service));
  }
}

abstract class SelectServiceEvent extends Equatable {
  const SelectServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadServices extends SelectServiceEvent {}

class ServiceSelected extends SelectServiceEvent {
  final NursingService service;

  const ServiceSelected({required this.service});

  @override
  List<Object> get props => [service];
}

abstract class SelectServiceState extends Equatable {
  const SelectServiceState();

  @override
  List<Object> get props => [];
}

class SelectServiceInitial extends SelectServiceState {}

class SelectServiceLoading extends SelectServiceState {}

class SelectServiceLoaded extends SelectServiceState {
  final List<NursingService> services;

  const SelectServiceLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

class SelectServiceError extends SelectServiceState {
  final String message;

  const SelectServiceError({required this.message});

  @override
  List<Object> get props => [message];
}

class ServiceSelectionSuccess extends SelectServiceState {
  final NursingService selectedService;

  const ServiceSelectionSuccess({required this.selectedService});

  @override
  List<Object> get props => [selectedService];
}