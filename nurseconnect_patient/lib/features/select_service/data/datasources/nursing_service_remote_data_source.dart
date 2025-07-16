import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class NursingServiceRemoteDataSource {
  Future<Either<Failure, List<NursingService>>> getNursingServices();
}