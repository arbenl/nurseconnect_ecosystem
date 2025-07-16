// lib/features/home/domain/repositories/service_request_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';


abstract class ServiceRequestRepository {
  // Returns the ID of the created request on success
  Future<Either<Failure, String>> createServiceRequest({
    required GeoPoint patientLocation,
    required UserData patientData,
    required String serviceDetails,
    required String paymentMethodId,
  });
}