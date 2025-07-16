import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class PatientProfileRepository {
  Future<Either<Failure, UserData>> getPatientProfile(String patientId);
}
