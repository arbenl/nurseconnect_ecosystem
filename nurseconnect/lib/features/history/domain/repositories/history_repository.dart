import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<ServiceRequestData>>> getCompletedServiceRequests(String nurseId);
}
