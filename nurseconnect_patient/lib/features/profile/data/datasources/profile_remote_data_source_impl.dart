import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';
import 'package:nurseconnect_patient/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseFunctions functions;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.functions,
    required this.storage,
  });

  @override
  Future<Either<Failure, UserData>> getPatientProfile(String patientId) async {
    try {
      final docSnapshot = await firestore.collection('users').doc(patientId).get();
      if (docSnapshot.exists) {
        return Right(UserData.fromSnapshot(docSnapshot));
      } else {
        return Left(ServerFailure(message: "Patient profile not found."));
      }
    } catch (e, stackTrace) {
      AppLogger.error("Error getting patient profile", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error getting patient profile');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updatePatientProfile(UserData userData) async {
    try {
      final callable = functions.httpsCallable('updatepatientprofile');
      await callable.call(userData.toJson());
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error("Error updating patient profile", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error updating patient profile');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Left(ServerFailure(message: 'No user logged in'));
      }

      final file = File(imagePath);
      final ref = storage.ref().child('profile_pictures').child('${user.uid}.jpg');
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();
      return Right(imageUrl);
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.error("Failed to upload image", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Failed to upload image');
      return Left(ServerFailure(message: 'Failed to upload image: ${e.message}'));
    } catch (e, stackTrace) {
      AppLogger.error("An unexpected error occurred during image upload", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'An unexpected error occurred during image upload');
      return Left(ServerFailure(message: 'An unexpected error occurred during image upload'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({required String password}) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Left(ServerFailure(message: 'No user logged in'));
      }

      final cred = EmailAuthProvider.credential(
          email: user.email!, password: password);

      await user.reauthenticateWithCredential(cred);

      // Call a Cloud Function to delete user's Firestore data first
      final callable = functions.httpsCallable('deletePatientAccount');
      await callable.call({'uid': user.uid});

      await user.delete(); // Delete Firebase Auth user

      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error("Failed to delete account", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Failed to delete account');
      return Left(ServerFailure(message: e.message ?? 'Failed to delete account'));
    } catch (e, stackTrace) {
      AppLogger.error("An unexpected error occurred during account deletion", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'An unexpected error occurred during account deletion');
      return Left(ServerFailure(message: 'An unexpected error occurred during account deletion'));
    }
  }

  @override
  Future<Either<Failure, void>> updateThemeMode(String themeMode) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Left(ServerFailure(message: 'No user logged in'));
      }
      await firestore.collection('users').doc(user.uid).update({'themeMode': themeMode});
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.error("Failed to update theme mode", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Failed to update theme mode');
      return Left(ServerFailure(message: 'Failed to update theme mode: ${e.message}'));
    } catch (e, stackTrace) {
      AppLogger.error("An unexpected error occurred during theme mode update", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'An unexpected error occurred during theme mode update');
      return Left(ServerFailure(message: 'An unexpected error occurred during theme mode update'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await auth.signOut();
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error("Error signing out", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error signing out');
      return Left(ServerFailure());
    }
  }
}
