import 'package:dartz/dartz.dart';
import 'package:nurseconnect_patient/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nurseconnect_patient/features/profile/domain/repositories/profile_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserData>> getPatientProfile(String patientId) async {
    return await remoteDataSource.getPatientProfile(patientId);
  }

  @override
  Future<Either<Failure, void>> updatePatientProfile(UserData userData) async {
    return await remoteDataSource.updatePatientProfile(userData);
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    return await remoteDataSource.uploadProfileImage(imagePath);
  }

  @override
  Future<Either<Failure, void>> deleteAccount({required String password}) async {
    return await remoteDataSource.deleteAccount(password: password);
  }

  @override
  Future<Either<Failure, void>> updateThemeMode(String themeMode) async {
    return await remoteDataSource.updateThemeMode(themeMode);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return await remoteDataSource.signOut();
  }
}