import 'package:nurseconnect_shared/models/nurse_profile_data.dart';
part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final NurseProfileData nurseProfile;

  const ProfileLoaded({required this.nurseProfile});

  @override
  List<Object> get props => [nurseProfile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
