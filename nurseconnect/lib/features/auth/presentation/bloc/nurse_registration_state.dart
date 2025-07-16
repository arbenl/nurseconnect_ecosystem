part of 'nurse_registration_bloc.dart';

abstract class NurseRegistrationState extends Equatable {
  const NurseRegistrationState();

  @override
  List<Object> get props => [];
}

class NurseRegistrationInitial extends NurseRegistrationState {}

class NurseRegistrationLoading extends NurseRegistrationState {}

class NurseRegistrationSuccess extends NurseRegistrationState {}

class NurseRegistrationFailure extends NurseRegistrationState {
  final String message;

  const NurseRegistrationFailure({required this.message});

  @override
  List<Object> get props => [message];
}