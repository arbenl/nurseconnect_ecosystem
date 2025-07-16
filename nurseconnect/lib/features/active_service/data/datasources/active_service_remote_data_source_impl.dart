import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';
import 'package:nurseconnect/features/active_service/data/datasources/active_service_remote_data_source.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ActiveServiceRemoteDataSourceImpl implements ActiveServiceRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;

  ActiveServiceRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseFunctions,
  });

  @override
  Stream<ServiceRequestData> getServiceRequestStream(String serviceRequestId) {
    return firestore
        .collection('serviceRequests')
        .doc(serviceRequestId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        // Log this as a non-fatal error, as the stream might just end or data might be temporarily unavailable
        AppLogger.log('Service request $serviceRequestId not found or data is empty in stream.', tag: 'ActiveServiceRemoteDataSource');
        FirebaseCrashlytics.instance.recordError(
          Exception('Service request $serviceRequestId not found or data is empty in stream.'),
          StackTrace.current,
          reason: 'Service request stream data missing',
          fatal: false,
        );
        throw Exception('Service request not found or data is empty.'); // Propagate error to stream listener
      }
      return ServiceRequestData.fromFirestore(snapshot);
    });
  }

  @override
  Future<Either<Failure, void>> completeServiceRequest(String serviceRequestId) async {
    try {
      final HttpsCallable callable = firebaseFunctions.httpsCallable('completeServiceRequest');
      await callable.call<void>({
        'serviceRequestId': serviceRequestId,
      });
      return const Right(null);
    } on FirebaseFunctionsException catch (e, stackTrace) {
      AppLogger.log('Error completing service request: ${e.message}', tag: 'ActiveServiceRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'FirebaseFunctionsException during completeServiceRequest');
      return Left(ServerFailure(message: e.message ?? 'Failed to complete service request.'));
    } catch (e, stackTrace) {
      AppLogger.log('An unexpected error occurred during completeServiceRequest: ${e.toString()}', tag: 'ActiveServiceRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Unexpected error during completeServiceRequest');
      return Left(ServerFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> submitRating(String serviceRequestId, double rating, String comment) async {
    try {
      AppLogger.log('Submitting rating for service $serviceRequestId: $rating stars, comment: $comment', tag: 'ActiveServiceRemoteDataSource');
      // Placeholder: In a real app, you would send this data to Firestore or a Cloud Function
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.log('Error submitting rating: ${e.toString()}', tag: 'ActiveServiceRemoteDataSource');
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error submitting rating');
      return Left(ServerFailure(message: 'Failed to submit rating.'));
    }
  }
}