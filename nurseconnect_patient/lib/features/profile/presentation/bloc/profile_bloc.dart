import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_patient/features/profile/domain/repositories/profile_repository.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadPatientProfile>(_onLoadProfile);
    on<ProfileUpdateSubmitted>(_onProfileUpdateSubmitted);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<DeleteAccountSubmitted>(_onDeleteAccountSubmitted);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<SignOutButtonPressed>(_onSignOutButtonPressed);
  }

  Future<void> _onLoadProfile(LoadPatientProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final profileResult = await profileRepository.getPatientProfile(event.patientId);

    profileResult.fold(
      (failure) => emit(const ProfileError(message: 'Failed to load profile')),
      (userData) => emit(ProfileLoaded(patientProfile: userData)),
    );
  }

  Future<void> _onProfileUpdateSubmitted(ProfileUpdateSubmitted event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await profileRepository.updatePatientProfile(event.userData);
    result.fold(
      (failure) => emit(ProfileError(message: 'Failed to update profile: ${failure.message}')),
      (_) => emit(ProfileUpdateSuccess(updatedProfile: event.userData)),
    );
  }

  Future<void> _onUploadProfileImage(
      UploadProfileImage event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await profileRepository.uploadProfileImage(event.imagePath);
    result.fold(
      (failure) => emit(ProfileError(message: 'Failed to upload image: ${failure.message}')),
      (imageUrl) {
        if (state is ProfileLoaded) {
          final updatedUserData = (state as ProfileLoaded).patientProfile.copyWith(
            profilePictureUrl: imageUrl,
          );
          add(ProfileUpdateSubmitted(userData: updatedUserData));
        } else {
          emit(const ProfileError(message: 'Failed to update profile with new image URL.'));
        }
      },
    );
  }

  Future<void> _onDeleteAccountSubmitted(
      DeleteAccountSubmitted event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await profileRepository.deleteAccount(password: event.password);
    result.fold(
      (failure) => emit(ProfileError(message: 'Failed to delete account: ${failure.message}')),
      (_) => emit(AccountDeletedSuccess()),
    );
  }

  Future<void> _onChangeThemeMode(
      ChangeThemeMode event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await profileRepository.updateThemeMode(event.themeMode);
    result.fold(
      (failure) => emit(ProfileError(message: 'Failed to change theme mode: ${failure.message}')),
      (_) {
        if (state is ProfileLoaded) {
          final updatedUserData = (state as ProfileLoaded).patientProfile.copyWith(
            themeMode: event.themeMode,
          );
          emit(ProfileLoaded(patientProfile: updatedUserData));
        }
      },
    );
  }

  Future<void> _onSignOutButtonPressed(
    SignOutButtonPressed event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await profileRepository.signOut();
    result.fold(
      (failure) => emit(const ProfileError(message: "Failed to sign out")),
      (_) => emit(ProfileSignOutSuccess()),
    );
  }
}

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadPatientProfile extends ProfileEvent {
  final String patientId;

  const LoadPatientProfile({required this.patientId});

  @override
  List<Object> get props => [patientId];
}

class ProfileUpdateSubmitted extends ProfileEvent {
  final UserData userData;

  const ProfileUpdateSubmitted({required this.userData});

  @override
  List<Object> get props => [userData];
}

 

class UploadProfileImage extends ProfileEvent {
  final String imagePath;

  const UploadProfileImage({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

class DeleteAccountSubmitted extends ProfileEvent {
  final String password;

  const DeleteAccountSubmitted({required this.password});

  @override
  List<Object> get props => [password];
}

/*
class Enable2FARequested extends ProfileEvent {
  final String phoneNumber;

  const Enable2FARequested({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class Verify2FA extends ProfileEvent {
  final String smsCode;

  const Verify2FA({required this.smsCode});

  @override
  List<Object> get props => [smsCode];
}

class Disable2FARequested extends ProfileEvent {
  const Disable2FARequested();

  @override
  List<Object> get props => [];
}
*/

class ChangeThemeMode extends ProfileEvent {
  final String themeMode;

  const ChangeThemeMode({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class SignOutButtonPressed extends ProfileEvent {}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserData patientProfile;

  const ProfileLoaded({required this.patientProfile});

  @override
  List<Object> get props => [patientProfile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class PasswordChangeSuccess extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final UserData updatedProfile;

  const ProfileUpdateSuccess({required this.updatedProfile});

  @override
  List<Object> get props => [updatedProfile];
}

class AccountDeletedSuccess extends ProfileState {}

class ProfileSignOutSuccess extends ProfileState {}

