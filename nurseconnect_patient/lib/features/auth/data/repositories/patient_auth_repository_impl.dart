import 'package:dartz/dartz.dart';
import 'package:nurseconnect_patient/features/auth/data/datasources/patient_auth_remote_data_source.dart';
import 'package:nurseconnect_patient/features/auth/domain/repositories/patient_auth_repository.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

class PatientAuthRepositoryImpl implements PatientAuthRepository {
  final PatientAuthRemoteDataSource remoteDataSource;

  PatientAuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserRole>> getUserRole(String uid) async {
    return await remoteDataSource.getUserRole(uid);
  }

  @override
  Future<Either<Failure, UserData>> getPatientProfile(String uid) async {
    return await remoteDataSource.getPatientProfile(uid);
  }
}
