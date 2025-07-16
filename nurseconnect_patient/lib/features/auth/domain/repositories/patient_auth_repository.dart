import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';


abstract class PatientAuthRepository {
  /// Checks Firestore for user/nurse document and returns role.
  /// Throws an exception on Firestore error. Returns unknown if user exists
  /// in Auth but not in /users or /nurses collections.
  Future<Either<Failure, UserRole>> getUserRole(String uid);

  /// Fetches patient profile data.
  /// Throws an an exception if the document isn't found, data is missing,
  /// or a Firestore error occurs.
  Future<Either<Failure, UserData>> getPatientProfile(String uid);

// TODO: Add other patient-specific auth related methods if needed (e.g., saving registration data)
}