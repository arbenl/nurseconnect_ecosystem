part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadNurseProfile extends ProfileEvent {
  final String nurseId;

  const LoadNurseProfile({required this.nurseId});

  @override
  List<Object> get props => [nurseId];
}
