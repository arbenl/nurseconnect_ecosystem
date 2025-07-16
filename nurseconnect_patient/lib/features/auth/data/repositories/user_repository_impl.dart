import 'package:dartz/dartz.dart';
import 'package:nurseconnect_patient/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:nurseconnect_patient/features/auth/domain/repositories/user_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserData>> getCurrentUserData() async {
    return await remoteDataSource.getCurrentUserData();
  }
}
