import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';
import 'package:nurseconnect_patient/features/history/data/datasources/history_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore firestore;

  HistoryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, List<ServiceRequestData>>> getServiceHistory(String userId) async {
    try {
      final snapshot = await firestore
          .collection('serviceRequests')
          .where('patientId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return Right(snapshot.docs
          .map((doc) => ServiceRequestData.fromFirestore(doc))
          .toList());
    } catch (e, stackTrace) {
      AppLogger.error("Error fetching service history", tag: "HistoryRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching service history');
      return Left(ServerFailure());
    }
  }
}
