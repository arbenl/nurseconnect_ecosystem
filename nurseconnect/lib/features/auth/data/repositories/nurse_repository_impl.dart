import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nurseconnect/features/auth/data/datasources/nurse_remote_data_source.dart';
import 'package:nurseconnect/features/auth/domain/repositories/nurse_repository.dart';
import 'package:nurseconnect_shared/core/error/failures.dart';

class NurseRepositoryImpl implements NurseRepository {
  final NurseRemoteDataSource remoteDataSource;

  NurseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createNurseProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    return await remoteDataSource.createNurseProfile(uid: uid, name: name, email: email);
  }

  @override
  Future<Either<Failure, void>> updateAvailability({
    required String uid,
    required bool isAvailable,
  }) async {
    return await remoteDataSource.updateAvailability(uid: uid, isAvailable: isAvailable);
  }

  @override
  Future<Either<Failure, void>> updateLocation({
    required String uid,
    required GeoPoint location,
    required String geohash,
  }) async {
    return await remoteDataSource.updateLocation(uid: uid, location: location, geohash: geohash);
  }
}
