// lib/features/auth/domain/repositories/user_repository.dart
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class UserRepository {
  Future<Either<Failure, UserData>> getCurrentUserData();
}