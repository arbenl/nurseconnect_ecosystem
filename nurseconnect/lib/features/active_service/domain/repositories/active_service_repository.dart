// lib/features/active_service/domain/repositories/active_service_repository.dart

import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

abstract class ActiveServiceRepository {
  Stream<ServiceRequestData> getServiceRequestStream(String serviceRequestId);
  Future<Either<Failure, void>> completeServiceRequest(String serviceRequestId);
  Future<Either<Failure, void>> submitRating(String serviceRequestId, double rating, String comment);
}
