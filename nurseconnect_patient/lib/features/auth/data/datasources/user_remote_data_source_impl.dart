import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';
import 'package:nurseconnect_patient/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<Either<Failure, UserData>> getCurrentUserData() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      return Left(ServerFailure(message: 'No authenticated user found.'));
    }
    try {
      final docSnapshot = await firestore.collection('users').doc(currentUser.uid).get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure(message: 'User data not found in Firestore.'));
      }
      return Right(UserData.fromSnapshot(docSnapshot));
    } catch (e, stackTrace) {
      AppLogger.error("Error fetching user data", tag: "UserRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching user data');
      return Left(ServerFailure());
    }
  }
}
