import 'package:dartz/dartz.dart';
import 'package:nurseconnect/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nurseconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserRole>> getUserRole(String uid) async {
    return await remoteDataSource.getUserRole(uid);
  }

  @override
  Future<Either<Failure, NurseProfileData>> getNurseProfile(String uid) async {
    return await remoteDataSource.getNurseProfile(uid);
  }
}
