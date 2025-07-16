part 'login_event.dart';
part 'login_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';
import 'package:nurseconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurseconnect_shared/models/user_role.dart';

export 'login_event.dart';
export 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth firebaseAuth;
  final AuthRepository authRepository;

  LoginBloc({
    required this.firebaseAuth,
    required this.authRepository,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        AppLogger.log("Firebase Login Successful: $uid", tag: 'LoginBloc');

        final userRoleResult = await authRepository.getUserRole(uid);

        userRoleResult.fold(
          (failure) async {
            AppLogger.log("Error checking user role via Repository: ${failure.toString()}", tag: 'LoginBloc');
            await firebaseAuth.signOut();
            emit(LoginFailure(message: "Error verifying user profile: ${failure.toString()}"));
          },
          (userRole) async {
            if (userRole == UserRole.nurse) {
              AppLogger.log("User identified as NURSE by Repository", tag: 'LoginBloc');
              emit(LoginSuccessNurse());
            } else if (userRole == UserRole.patient) {
              AppLogger.log("User identified as PATIENT - Cannot access Nurse App", tag: 'LoginBloc');
              await firebaseAuth.signOut();
              emit(const LoginFailure(message: "You logged in as a patient. Please use the Patient App."));
            } else {
              AppLogger.log("User authenticated but role unknown or profile not found.", tag: 'LoginBloc');
              await firebaseAuth.signOut();
              emit(const LoginFailure(message: "Login successful, but user profile/role not found."));
            }
          },
        );
      } else {
        AppLogger.log("Firebase Login Warning: User credential is null", tag: 'LoginBloc');
        emit(const LoginFailure(message: "Login failed. Please try again."));
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.log("Firebase Login Error Code: ${e.code}", tag: 'LoginBloc');
      String message = "An unknown login error occurred.";
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else if (e.code == 'user-disabled') {
        message = 'This user account has been disabled.';
      }
      emit(LoginFailure(message: message));
    } catch (e) {
      AppLogger.log("Unexpected Login Error: $e", tag: 'LoginBloc');
      emit(const LoginFailure(message: "An unexpected error occurred during login."));
    }
  }
}