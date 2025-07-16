import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class HistoryRemoteDataSource {
  Future<Either<Failure, List<ServiceRequestData>>> getCompletedServiceRequests(String nurseId);
}