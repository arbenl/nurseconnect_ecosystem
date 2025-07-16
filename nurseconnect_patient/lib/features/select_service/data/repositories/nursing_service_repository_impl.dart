import 'package:dartz/dartz.dart';
import 'package:nurseconnect_patient/features/select_service/data/datasources/nursing_service_remote_data_source.dart';
import 'package:nurseconnect_patient/features/select_service/domain/repositories/nursing_service_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class NursingServiceRepositoryImpl implements NursingServiceRepository {
  final NursingServiceRemoteDataSource remoteDataSource;

  NursingServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NursingService>>> getNursingServices() async {
    return await remoteDataSource.getNursingServices();
  }
}