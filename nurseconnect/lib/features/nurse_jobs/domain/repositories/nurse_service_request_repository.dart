import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

abstract class NurseServiceRequestRepository {
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