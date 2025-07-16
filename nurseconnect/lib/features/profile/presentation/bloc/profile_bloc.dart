part 'profile_event.dart';
part 'profile_state.dart';

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nurseconnect/features/profile/domain/repositories/profile_repository.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadNurseProfile>(_onLoadNurseProfile);
  }

  Future<void> _onLoadNurseProfile(
      LoadNurseProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final nurseProfileResult = await profileRepository.getNurseProfile(event.nurseId);
      nurseProfileResult.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (nurseProfile) => emit(ProfileLoaded(nurseProfile: nurseProfile)),
      );
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
