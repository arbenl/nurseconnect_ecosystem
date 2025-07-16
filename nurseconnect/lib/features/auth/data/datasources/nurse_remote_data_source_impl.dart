import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';
import 'package:nurseconnect/features/auth/data/datasources/nurse_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

class NurseRemoteDataSourceImpl implements NurseRemoteDataSource {
  final FirebaseFirestore firestore;

  NurseRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, void>> createNurseProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      final docRef = firestore.collection('nurses').doc(uid);

      final Map<String, dynamic> nurseData = {
        'uid': uid,
        'name': name,
        'email': email,
        'role': 'nurse',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isAvailable': true,
        'currentLocation': null,
        'geohash': null,
      };

      await docRef.set(nurseData);
      AppLogger.log("Nurse profile created in Firestore for UID: $uid", tag: 'NurseRemoteDataSource');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.log("Error creating nurse profile in Firestore: $e", tag: 'NurseRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error creating nurse profile');
      return Left(ServerFailure(message: 'Failed to create nurse profile.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAvailability({
    required String uid,
    required bool isAvailable,
  }) async {
    try {
      final docRef = firestore.collection('nurses').doc(uid);
      await docRef.update({
        'isAvailable': isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.log("Nurse ($uid) availability updated to: $isAvailable", tag: 'NurseRemoteDataSource');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.log("Error updating nurse availability for $uid: $e", tag: 'NurseRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error updating nurse availability');
      return Left(ServerFailure(message: 'Failed to update availability.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocation({
    required String uid,
    required GeoPoint location,
    required String geohash,
  }) async {
    try {
      final docRef = firestore.collection('nurses').doc(uid);
      await docRef.update({
        'currentLocation': location,
        'geohash': geohash,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.log("Nurse ($uid) location updated.", tag: 'NurseRemoteDataSource');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.log("Error updating nurse location for $uid: $e", tag: 'NurseRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error updating nurse location');
      return Left(ServerFailure(message: 'Failed to update location.'));
    }
  }
}
