import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';
import 'package:nurseconnect_patient/features/home/data/datasources/service_request_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ServiceRequestRemoteDataSourceImpl implements ServiceRequestRemoteDataSource {
  final FirebaseFirestore firestore;

  ServiceRequestRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, String>> createServiceRequest({
    required GeoPoint patientLocation,
    required UserData patientData,
    required String serviceDetails,
    required String paymentMethodId,
  }) async {
    try {
      final docRef = firestore.collection('serviceRequests').doc();

      final requestData = ServiceRequestData(
        requestId: docRef.id,
        patientId: patientData.uid,
        patientName: patientData.name,
        patientLocation: patientLocation,
        requestTimestamp: Timestamp.now(),
        status: ServiceRequestStatus.pending,
        serviceDetails: serviceDetails,
        paymentMethodId: paymentMethodId,
      );

      await docRef.set(requestData.toJson());

      AppLogger.log("Service Request created with ID: ${docRef.id}", tag: "ServiceRequestRemoteDataSource");
      return Right(docRef.id);
    } catch (e, stackTrace) {
      AppLogger.error("Error creating service request", tag: "ServiceRequestRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error creating service request');
      return Left(ServerFailure());
    }
  }
}
