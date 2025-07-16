import 'package:dartz/dartz.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NurseRemoteDataSource {
  Future<Either<Failure, void>> createNurseProfile({
    required String uid,
    required String name,
    required String email,
  });
  Future<Either<Failure, void>> updateAvailability({
    required String uid,
    required bool isAvailable,
  });
  Future<Either<Failure, void>> updateLocation({
    required String uid,
    required GeoPoint location,
    required String geohash,
  });
}