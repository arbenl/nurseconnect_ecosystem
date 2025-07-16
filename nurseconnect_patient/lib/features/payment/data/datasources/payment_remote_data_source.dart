import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

abstract class PaymentRemoteDataSource {
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods(String userId);
  Future<Either<Failure, PaymentMethod>> addPaymentMethod(String userId, Map<String, dynamic> paymentDetails);
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId);
  Future<Either<Failure, void>> setDefaultPaymentMethod(String userId, String paymentMethodId);
}