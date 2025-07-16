import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';
import 'package:nurseconnect_patient/features/select_service/data/datasources/nursing_service_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class NursingServiceRemoteDataSourceImpl implements NursingServiceRemoteDataSource {
  final FirebaseFirestore firestore;

  NursingServiceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, List<NursingService>>> getNursingServices() async {
    try {
      final querySnapshot = await firestore.collection('nursingServices').get();
      return Right(querySnapshot.docs
          .map((doc) => NursingService.fromMap(doc.id, doc.data()))
          .toList());
    } catch (e, stackTrace) {
      AppLogger.error("Error fetching nursing services", tag: "NursingServiceRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching nursing services');
      return Left(ServerFailure());
    }
  }
}
