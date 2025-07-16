import 'package:dartz/dartz.dart';
import 'package:nurseconnect/features/history/data/datasources/history_remote_data_source.dart';
import 'package:nurseconnect/features/history/domain/repositories/history_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServiceRequestData>>> getCompletedServiceRequests(String nurseId) async {
    return await remoteDataSource.getCompletedServiceRequests(nurseId);
  }
}