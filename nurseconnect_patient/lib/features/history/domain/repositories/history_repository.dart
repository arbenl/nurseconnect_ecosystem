import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<ServiceRequestData>>> getServiceHistory(String userId);
}
