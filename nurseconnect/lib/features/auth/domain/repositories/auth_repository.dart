// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';

import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

abstract class AuthRepository {
  /// Checks Firestore for user/nurse document and returns role.
  /// Throws an exception on Firestore error. Returns unknown if user exists
  /// in Auth but not in /users or /nurses collections.
  Future<Either<Failure, UserRole>> getUserRole(String uid);

  /// Fetches nurse profile data.
  /// Throws an exception if the document isn't found, data is missing,
  /// or a Firestore error occurs.
  Future<Either<Failure, NurseProfileData>> getNurseProfile(String uid);

// TODO: Add Future<UserData> getPatientProfile(String uid) if needed
}