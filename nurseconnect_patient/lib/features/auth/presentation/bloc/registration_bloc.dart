import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  RegistrationBloc({
    required this.firebaseAuth,
    required this.firestore,
  }) : super(RegistrationInitial()) {
    on<RegistrationSubmitted>(_onRegistrationSubmitted);
  }

  Future<void> _onRegistrationSubmitted(
      RegistrationSubmitted event,
      Emitter<RegistrationState> emit,
      ) async {
    emit(RegistrationLoading());
    User? userToDelete; // Keep track of the user to delete on failure
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      if (userCredential.user != null) {
        userToDelete = userCredential.user; // User created, might need to delete if next step fails
        AppLogger.log("Firebase Registration Successful: ${userCredential.user!.uid}", tag: "RegistrationBloc");

        // This will now be caught by the outer catch block on failure
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': event.name.trim(),
          'email': event.email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'patient',
          if (event.phoneNumber != null) 'phoneNumber': event.phoneNumber!.trim(),
        });
        AppLogger.log("User data saved to Firestore for UID: ${userCredential.user!.uid}", tag: "RegistrationBloc");

        emit(RegistrationSuccess());
      } else {
        AppLogger.log("Firebase Registration Warning: User credential is null", tag: "RegistrationBloc");
        emit(const RegistrationFailure(message: "Registration failed. Please try again."));
      }

    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error("Firebase Registration Error Code: ${e.code}", tag: "RegistrationBloc", error: e, stackTrace: stackTrace);
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        default:
          message = 'An unknown registration error occurred.';
      }
      emit(RegistrationFailure(message: message));
    } catch (e, stackTrace) {
      AppLogger.error("Unexpected Registration Error", tag: "RegistrationBloc", error: e, stackTrace: stackTrace);
      // **THE FIX**
      // If user was created in Auth but Firestore failed, delete the user to allow retry.
      if (userToDelete != null) {
        AppLogger.log("Firestore write failed. Deleting created Firebase Auth user: ${userToDelete.uid}", tag: "RegistrationBloc");
        await userToDelete.delete();
      }
      emit(const RegistrationFailure(message: "Failed to save profile. Please try again."));
    }
  }
}

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegistrationSubmitted extends RegistrationEvent {
  final String name;
  final String email;
  final String password;
  final String? phoneNumber;

  const RegistrationSubmitted({
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [name, email, password, phoneNumber];
}

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String message;

  const RegistrationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
