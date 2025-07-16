import 'package:dartz/dartz.dart';
import 'package:nurseconnect_patient/features/home/data/datasources/service_request_remote_data_source.dart';
import 'package:nurseconnect_patient/features/home/domain/repositories/service_request_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final ServiceRequestRemoteDataSource remoteDataSource;

  ServiceRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> createServiceRequest({
    required GeoPoint patientLocation,
    required UserData patientData,
    required String serviceDetails,
    required String paymentMethodId,
  }) async {
    return await remoteDataSource.createServiceRequest(
      patientLocation: patientLocation,
      patientData: patientData,
      serviceDetails: serviceDetails,
      paymentMethodId: paymentMethodId,
    );
  }
}
