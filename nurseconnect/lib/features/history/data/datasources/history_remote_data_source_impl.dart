import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';
import 'package:nurseconnect/features/history/data/datasources/history_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore firestore;

  HistoryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, List<ServiceRequestData>>> getCompletedServiceRequests(String nurseId) async {
    try {
      final querySnapshot = await firestore
          .collection('serviceRequests')
          .where('assignedNurseId', isEqualTo: nurseId)
          .where('status', isEqualTo: 'completed')
          .orderBy('completedAt', descending: true)
          .get();

      return Right(querySnapshot.docs
          .map((doc) => ServiceRequestData.fromFirestore(doc))
          .toList());
    } catch (e, stackTrace) {
      AppLogger.log("Error fetching completed service requests: $e", tag: "HistoryRemoteDataSource");
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching completed service requests');
      return Left(ServerFailure());
    }
  }
}
