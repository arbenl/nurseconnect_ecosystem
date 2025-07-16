import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';
import 'package:nurseconnect/features/nurse_jobs/data/datasources/nurse_service_request_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class NurseServiceRequestRemoteDataSourceImpl implements NurseServiceRequestRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;

  NurseServiceRequestRemoteDataSourceImpl({required this.firestore, required this.firebaseFunctions});

  @override
  Stream<List<ServiceRequestData>> getOffersForNurse(String nurseId) {
    return firestore
        .collection('serviceRequests')
        .where('offeredToNurseId', isEqualTo: nurseId)
        .where('status', isEqualTo: 'offered')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ServiceRequestData.fromFirestore(doc))
        .toList());
  }

  @override
  Future<Either<Failure, void>> respondToOffer({
    required String requestId,
    required String nurseId,
    required String response,
  }) async {
    try {
      final callable = firebaseFunctions.httpsCallable('respondToOffer');
      await callable.call({
        'requestId': requestId,
        'nurseId': nurseId,
        'response': response,
      });
      return const Right(null);
    } on FirebaseFunctionsException catch (e, stackTrace) {
      AppLogger.log('Error responding to offer: ${e.message}', tag: 'NurseServiceRequestRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'FirebaseFunctionsException during respondToOffer');
      return Left(ServerFailure(message: e.message ?? 'Failed to respond to offer.'));
    } catch (e, stackTrace) {
      AppLogger.log('An unexpected error occurred during respondToOffer: ${e.toString()}', tag: 'NurseServiceRequestRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Unexpected error during respondToOffer');
      return Left(ServerFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateJobStatus({
    required String requestId,
    required String nurseId,
    required String status,
  }) async {
    try {
      final requestRef = firestore.collection('serviceRequests').doc(requestId);

      await firestore.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(requestRef);
        if (docSnapshot.exists && docSnapshot.data() != null) {
          transaction.update(requestRef, {
            'status': status,
          });

          if (status == 'completed') {
            final nurseRef = firestore.collection('nurses').doc(nurseId);
            transaction.update(nurseRef, {'isAvailable': true});
          }
        } else {
          throw Exception("Service request not found for status update.");
        }
      });
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.log('Error updating job status: ${e.toString()}', tag: 'NurseServiceRequestRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error updating job status');
      return Left(ServerFailure(message: 'Failed to update job status.'));
    }
  }
}
