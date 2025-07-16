// lib/features/auth/domain/repositories/nurse_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

abstract class NurseRepository {
  /// Creates a new nurse profile document in Firestore.
  ///
  /// Throws an exception if the operation fails. Consider using Either&lt;Failure, void&gt; for robust error handling.
  Future<void> createNurseProfile({
    required String uid,
    required String name,
    required String email,
    // Add other required fields collected during registration if any
  });

// Add other methods later if needed, e.g.:
// Future<NurseData> getNurseData(String uid);
  Future<void> updateAvailability({required String uid, required bool isAvailable});

  // *** ADD THIS METHOD SIGNATURE ***
  /// Updates the location and geohash for the given nurse UID.
  Future<Either<Failure, void>> updateLocation({
    required String uid,
    required GeoPoint location,
    required String geohash
  });
// *** END SIGNATURE ***
// Future<void> updateNurseLocation(String uid, GeoPoint location);
}