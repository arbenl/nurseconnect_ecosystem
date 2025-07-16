import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurseconnect_patient/features/auth/domain/repositories/patient_auth_repository.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth firebaseAuth;
  final PatientAuthRepository patientAuthRepository;
  final FirebaseFunctions firebaseFunctions;

  LoginBloc({
    required this.firebaseAuth,
    required this.patientAuthRepository,
    required this.firebaseFunctions,
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
        AppLogger.log("Firebase Login Successful: $uid", tag: "LoginBloc");

        final userRoleEither = await patientAuthRepository.getUserRole(uid);

        await userRoleEither.fold(
          (failure) async {
            AppLogger.error("Error checking user role via Repository: ${failure.message}", tag: "LoginBloc");
            await firebaseAuth.signOut();
            emit(LoginFailure(message: "Error verifying user profile: ${failure.message}"));
          },
          (userRole) async {
            if (userRole == UserRole.patient) {
              AppLogger.log("User identified as PATIENT by Repository", tag: "LoginBloc");

              final fcmToken = await FirebaseMessaging.instance.getToken();
              if (fcmToken != null) {
                try {
                  final callable = firebaseFunctions.httpsCallable('updateFcmToken');
                  await callable.call({'fcmToken': fcmToken});
                  AppLogger.log("Successfully called updateFcmToken Cloud Function for patient $uid", tag: "LoginBloc");
                  // Only emit success after the token is updated.
                  emit(LoginSuccessPatient());
                } catch (e, stackTrace) {
                  AppLogger.error("Error calling updateFcmToken function, logging user out.", tag: "LoginBloc", error: e, stackTrace: stackTrace);
                  await firebaseAuth.signOut();
                  emit(const LoginFailure(message: "Couldn't save session. Please try again."));
                }
              } else {
                AppLogger.error("FCM token is null, logging user out.", tag: "LoginBloc");
                await firebaseAuth.signOut();
                emit(const LoginFailure(message: "Couldn't get session token. Please try again."));
              }
            } else {
              AppLogger.log("User authenticated but not a patient", tag: "LoginBloc");
              await firebaseAuth.signOut();
              emit(const LoginFailure(message: "Login successful, but user profile not found."));
            }
          },
        );
      } else {
        AppLogger.log("Firebase Login Warning: User credential is null", tag: "LoginBloc");
        emit(const LoginFailure(message: "Login failed. Please try again."));
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error("Firebase Login Error Code: ${e.code}", tag: "LoginBloc", error: e, stackTrace: stackTrace);
      String message;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Invalid email or password. Please try again.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many login attempts. Please try again later.';
          break;
        default:
          message = 'An unknown login error occurred.';
      }
      emit(LoginFailure(message: message));
    } catch (e, stackTrace) {
      AppLogger.error("Unexpected Login Error", tag: "LoginBloc", error: e, stackTrace: stackTrace);
      emit(const LoginFailure(message: "An unexpected error occurred during login."));
    }
  }
}

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccessPatient extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({required this.message});

  @override
  List<Object> get props => [message];
}