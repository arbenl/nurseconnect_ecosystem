import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';
import 'package:nurseconnect/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl({required this.firestore});

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
      AppLogger.log("Error fetching nurse profile for $uid: $e", tag: 'ProfileRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching nurse profile');
      return Left(ServerFailure(message: "Failed to fetch nurse profile."));
    }
  }
}
