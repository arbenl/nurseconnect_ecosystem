part of 'nurse_registration_bloc.dart';

abstract class NurseRegistrationEvent extends Equatable {
  const NurseRegistrationEvent();

  @override
  List<Object> get props => [];
}

class NurseRegistrationSubmitted extends NurseRegistrationEvent {
  final String name;
  final String email;
  final String password;

  const NurseRegistrationSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}