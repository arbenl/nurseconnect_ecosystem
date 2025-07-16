import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class ActiveServiceRemoteDataSource {
  Stream<ServiceRequestData> getServiceRequestStream(String serviceRequestId);
  Future<Either<Failure, void>> completeServiceRequest(String serviceRequestId);
  Future<Either<Failure, void>> submitRating(String serviceRequestId, double rating, String comment);
}