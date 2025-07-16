import 'package:dartz/dartz.dart';
import 'package:nurseconnect/features/nurse_jobs/data/datasources/nurse_service_request_remote_data_source.dart';
import 'package:nurseconnect/features/nurse_jobs/domain/repositories/nurse_service_request_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class NurseServiceRequestRepositoryImpl implements NurseServiceRequestRepository {
  final NurseServiceRequestRemoteDataSource remoteDataSource;

  NurseServiceRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ServiceRequestData>> getOffersForNurse(String nurseId) {
    return remoteDataSource.getOffersForNurse(nurseId);
  }

  @override
  Future<Either<Failure, void>> respondToOffer({
    required String requestId,
    required String nurseId,
    required String response,
  }) async {
    return await remoteDataSource.respondToOffer(requestId: requestId, nurseId: nurseId, response: response);
  }

  @override
  Future<Either<Failure, void>> updateJobStatus({
    required String requestId,
    required String nurseId,
    required String status,
  }) async {
    return await remoteDataSource.updateJobStatus(requestId: requestId, nurseId: nurseId, status: status);
  }
}
