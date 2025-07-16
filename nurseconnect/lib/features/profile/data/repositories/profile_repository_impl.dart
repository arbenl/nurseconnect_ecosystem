import 'package:dartz/dartz.dart';
import 'package:nurseconnect/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nurseconnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NurseProfileData>> getNurseProfile(String nurseId) async {
    return await remoteDataSource.getNurseProfile(nurseId);
  }
}