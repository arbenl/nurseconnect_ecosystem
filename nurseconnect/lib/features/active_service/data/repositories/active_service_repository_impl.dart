import 'package:dartz/dartz.dart';
import 'package:nurseconnect/features/active_service/data/datasources/active_service_remote_data_source.dart';
import 'package:nurseconnect/features/active_service/domain/repositories/active_service_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ActiveServiceRepositoryImpl implements ActiveServiceRepository {
  final ActiveServiceRemoteDataSource remoteDataSource;

  ActiveServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<ServiceRequestData> getServiceRequestStream(String serviceRequestId) {
    return remoteDataSource.getServiceRequestStream(serviceRequestId);
  }

  @override
  Future<Either<Failure, void>> completeServiceRequest(String serviceRequestId) async {
    return await remoteDataSource.completeServiceRequest(serviceRequestId);
  }

  @override
  Future<Either<Failure, void>> submitRating(String serviceRequestId, double rating, String comment) async {
    return await remoteDataSource.submitRating(serviceRequestId, rating, comment);
  }
}