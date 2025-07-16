import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class NurseServiceRequestRemoteDataSource {
  Stream<List<ServiceRequestData>> getOffersForNurse(String nurseId);
  Future<Either<Failure, void>> respondToOffer({
    required String requestId,
    required String nurseId,
    required String response,
  });
  Future<Either<Failure, void>> updateJobStatus({
    required String requestId,
    required String nurseId,
    required String status,
  });
}
