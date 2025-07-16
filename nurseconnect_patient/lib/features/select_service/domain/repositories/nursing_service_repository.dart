import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class NursingServiceRepository {
  Future<Either<Failure, List<NursingService>>> getNursingServices();
}
