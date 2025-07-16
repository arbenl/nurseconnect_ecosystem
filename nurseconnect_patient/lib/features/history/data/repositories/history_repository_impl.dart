import 'package:dartz/dartz.dart';
import 'package:nurseconnect_patient/features/history/data/datasources/history_remote_data_source.dart';
import 'package:nurseconnect_patient/features/history/domain/repositories/history_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServiceRequestData>>> getServiceHistory(String userId) async {
    return await remoteDataSource.getServiceHistory(userId);
  }
}