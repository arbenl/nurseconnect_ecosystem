import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserData>> getPatientProfile(String patientId);
  Future<Either<Failure, void>> updatePatientProfile(UserData userData);
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);
  Future<Either<Failure, void>> deleteAccount({required String password});
  Future<Either<Failure, void>> updateThemeMode(String themeMode);
  Future<Either<Failure, void>> signOut();
}
