import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, NurseProfileData>> getNurseProfile(String nurseId);
}
