import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ServiceRequestRemoteDataSource {
  Future<Either<Failure, String>> createServiceRequest({
    required GeoPoint patientLocation,
    required UserData patientData,
    required String serviceDetails,
    required String paymentMethodId,
  });
}