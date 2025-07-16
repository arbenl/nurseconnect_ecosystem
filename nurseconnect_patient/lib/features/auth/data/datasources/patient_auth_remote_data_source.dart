import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class PatientAuthRemoteDataSource {
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserRole>> getUserRole(String uid);
  Future<Either<Failure, UserData>> getPatientProfile(String uid);
}
