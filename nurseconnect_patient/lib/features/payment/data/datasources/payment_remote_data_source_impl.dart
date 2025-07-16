import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';
import 'package:nurseconnect_patient/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFirestore firestore;

  PaymentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('paymentMethods')
          .where('userId', isEqualTo: userId)
          .get();
      return Right(querySnapshot.docs
          .map((doc) => PaymentMethod.fromMap(doc.id, doc.data()))
          .toList());
    } catch (e, stackTrace) {
      AppLogger.error("Error fetching payment methods for user $userId", tag: "PaymentRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching payment methods');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PaymentMethod>> addPaymentMethod(String userId, Map<String, dynamic> paymentDetails) async {
    try {
      final newDocRef = firestore.collection('paymentMethods').doc();
      final newPaymentMethod = PaymentMethod(
        id: newDocRef.id,
        userId: userId,
        cardType: paymentDetails['cardType'] ?? 'Unknown',
        last4: paymentDetails['last4'] ?? '',
        brand: paymentDetails['brand'] ?? 'Unknown',
        stripePaymentMethodId: 'simulated_pm_${newDocRef.id}',
        isDefault: paymentDetails['isDefault'] ?? false,
      );

      await newDocRef.set(newPaymentMethod.toMap());
      AppLogger.log("Added simulated payment method for user $userId", tag: "PaymentRemoteDataSource");
      return Right(newPaymentMethod);
    } catch (e, stackTrace) {
      AppLogger.error("Error adding payment method for user $userId", tag: "PaymentRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error adding payment method');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId) async {
    try {
      await firestore.collection('paymentMethods').doc(paymentMethodId).delete();
      AppLogger.log("Deleted payment method $paymentMethodId", tag: "PaymentRemoteDataSource");
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error("Error deleting payment method $paymentMethodId", tag: "PaymentRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error deleting payment method');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultPaymentMethod(String userId, String paymentMethodId) async {
    try {
      final batch = firestore.batch();
      final currentDefaults = await firestore
          .collection('paymentMethods')
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .get();

      for (var doc in currentDefaults.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      batch.update(firestore.collection('paymentMethods').doc(paymentMethodId), {'isDefault': true});

      await batch.commit();
      AppLogger.log("Set payment method $paymentMethodId as default for user $userId", tag: "PaymentRemoteDataSource");
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error("Error setting default payment method $paymentMethodId for user $userId", tag: "PaymentRemoteDataSource", error: e, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error setting default payment method');
      return Left(ServerFailure());
    }
  }
}