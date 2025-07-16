import 'package:dartz/dartz.dart';
import 'package:nurseconnect_patient/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:nurseconnect_patient/features/payment/domain/repositories/payment_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods(String userId) async {
    return await remoteDataSource.getPaymentMethods(userId);
  }

  @override
  Future<Either<Failure, PaymentMethod>> addPaymentMethod(String userId, Map<String, dynamic> paymentDetails) async {
    return await remoteDataSource.addPaymentMethod(userId, paymentDetails);
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId) async {
    return await remoteDataSource.deletePaymentMethod(paymentMethodId);
  }

  @override
  Future<Either<Failure, void>> setDefaultPaymentMethod(String userId, String paymentMethodId) async {
    return await remoteDataSource.setDefaultPaymentMethod(userId, paymentMethodId);
  }
}