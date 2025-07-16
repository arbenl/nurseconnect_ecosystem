import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_patient/features/profile/domain/repositories/patient_profile_repository.dart';
import 'package:nurseconnect_patient/features/auth/domain/repositories/patient_auth_repository.dart';

class PatientProfileRepositoryImpl implements PatientProfileRepository {
  final PatientAuthRepository patientAuthRepository;

  PatientProfileRepositoryImpl({required this.patientAuthRepository});

  @override
  Future<Either<Failure, UserData>> getPatientProfile(String patientId) {
    return patientAuthRepository.getPatientProfile(patientId);
  }
}
