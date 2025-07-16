import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';
import 'package:nurseconnect/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return Right(userCredential);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.log("Firebase Auth Error: ${e.code} - ${e.message}", tag: 'AuthRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Firebase Auth Exception during sign-in');
      return Left(ServerFailure(message: e.message ?? 'An authentication error occurred.'));
    } catch (e, stackTrace) {
      AppLogger.log("Unexpected Error during sign-in: $e", tag: 'AuthRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Unexpected error during sign-in');
      return Left(ServerFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, UserRole>> getUserRole(String uid) async {
    final nurseDocRef = firestore.collection('nurses').doc(uid);
    final userDocRef = firestore.collection('users').doc(uid);

    try {
      final results = await Future.wait([
        nurseDocRef.get(),
        userDocRef.get(),
      ]);

      final nurseDoc = results[0];
      final userDoc = results[1];

      if (nurseDoc.exists) {
        return const Right(UserRole.nurse);
      } else if (userDoc.exists) {
        return const Right(UserRole.patient);
      } else {
        AppLogger.log("Warning: User $uid authenticated but profile not found.", tag: 'AuthRemoteDataSource');
        return const Right(UserRole.unknown);
      }
    } catch (e, stackTrace) {
      AppLogger.log("Error checking user role for $uid: $e", tag: 'AuthRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error checking user role');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NurseProfileData>> getNurseProfile(String uid) async {
    try {
      final docSnapshot = await firestore.collection('nurses').doc(uid).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return Right(NurseProfileData.fromMap(uid, docSnapshot.data()!));
      } else {
        return Left(ServerFailure(message: "Nurse profile not found or data missing for UID: $uid"));
      }
    } catch (e, stackTrace) {
      AppLogger.log("Error fetching nurse profile for $uid: $e", tag: 'AuthRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching nurse profile');
      return Left(ServerFailure(message: "Failed to fetch nurse profile."));
    }
  }
}
