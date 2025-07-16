part 'nurse_registration_event.dart';
part 'nurse_registration_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurseconnect/features/auth/domain/repositories/nurse_repository.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';

export 'nurse_registration_event.dart';
export 'nurse_registration_state.dart';

class NurseRegistrationBloc extends Bloc<NurseRegistrationEvent, NurseRegistrationState> {
  final FirebaseAuth firebaseAuth;
  final NurseRepository nurseRepository;

  NurseRegistrationBloc({
    required this.firebaseAuth,
    required this.nurseRepository,
  }) : super(NurseRegistrationInitial()) {
    on<NurseRegistrationSubmitted>(_onNurseRegistrationSubmitted);
  }

  Future<void> _onNurseRegistrationSubmitted(
      NurseRegistrationSubmitted event,
      Emitter<NurseRegistrationState> emit,
      ) async {
    emit(NurseRegistrationLoading());
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        AppLogger.log("Firebase Nurse Registration Successful: $uid", tag: 'NurseRegistrationBloc');

        await nurseRepository.createNurseProfile(
          uid: uid,
          name: event.name.trim(),
          email: event.email.trim(),
        );
        AppLogger.log("Nurse data saved to Firestore for UID: $uid", tag: 'NurseRegistrationBloc');

        emit(NurseRegistrationSuccess());
      } else {
        AppLogger.log("Firebase Nurse Registration Warning: User credential is null", tag: 'NurseRegistrationBloc');
        emit(const NurseRegistrationFailure(message: "Registration failed (null user). Please try again."));
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.log("Firebase Nurse Registration Error Code: ${e.code}", tag: 'NurseRegistrationBloc');
      String message = "An unknown registration error occurred.";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }
      emit(NurseRegistrationFailure(message: message));
    } catch (e) {
      AppLogger.log("Unexpected Nurse Registration Error: $e", tag: 'NurseRegistrationBloc');
      emit(const NurseRegistrationFailure(message: "An unexpected error occurred during nurse registration."));
    }
  }
}