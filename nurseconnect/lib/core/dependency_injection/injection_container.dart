// lib/core/dependency_injection/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

// Import feature dependencies when they are created
import '../../features/auth/presentation/bloc/login_bloc.dart';
import 'package:nurseconnect/features/auth/domain/repositories/nurse_repository.dart';
import 'package:nurseconnect/features/auth/data/repositories/nurse_repository_impl.dart';
import 'package:nurseconnect/features/auth/presentation/bloc/nurse_registration_bloc.dart';
import 'package:nurseconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurseconnect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nurseconnect/features/home/presentation/bloc/nurse_home_bloc.dart';
import 'package:nurseconnect/features/nurse_jobs/domain/repositories/nurse_service_request_repository.dart';
import 'package:nurseconnect/features/nurse_jobs/data/repositories/nurse_service_request_repository_impl.dart';
import '../../features/active_service/data/repositories/active_service_repository_impl.dart';
import '../../features/active_service/domain/repositories/active_service_repository.dart';
import '../../features/active_service/presentation/bloc/active_service_bloc.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nurseconnect/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nurseconnect/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:nurseconnect/features/active_service/data/datasources/active_service_remote_data_source.dart';
import 'package:nurseconnect/features/active_service/data/datasources/active_service_remote_data_source_impl.dart';
import 'package:nurseconnect/features/auth/data/datasources/nurse_remote_data_source.dart';
import 'package:nurseconnect/features/auth/data/datasources/nurse_remote_data_source_impl.dart';
import 'package:nurseconnect/features/history/data/datasources/history_remote_data_source.dart';
import 'package:nurseconnect/features/history/data/datasources/history_remote_data_source_impl.dart';
import 'package:nurseconnect/features/nurse_jobs/data/datasources/nurse_service_request_remote_data_source.dart';
import 'package:nurseconnect/features/nurse_jobs/data/datasources/nurse_service_request_remote_data_source_impl.dart';
import 'package:nurseconnect/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nurseconnect/features/profile/data/datasources/profile_remote_data_source_impl.dart';


// Create a global instance of GetIt
final sl = GetIt.instance; // sl stands for Service Locator

// Asynchronous function to initialize all dependencies
Future<void> init() async {

  // --- Features ---

  // Feature: Auth
  // Register dependencies required for the Authentication feature

  // Bloc
  // We use registerFactory for Blocs because we often want a new instance
  // each time we need one (e.g., for each screen that uses it).
  // Bloc (Login)
  sl.registerFactory(
    () => LoginBloc(
      firebaseAuth: sl(),
      authRepository: sl(),
    ),
  );


  // Nurse Registration Bloc
  sl.registerFactory(
    () => NurseRegistrationBloc(
      firebaseAuth: sl(),
      nurseRepository: sl<NurseRepository>(),
    ),
  );

  // *** ADD NURSE HOME BLOC ***
  sl.registerFactory(
    () => NurseHomeBloc(
      nurseRepository: sl(),
      firebaseAuth: sl(),
      authRepository: sl(),
      firebaseFunctions: sl(),
      nurseServiceRequestRepository: sl<NurseServiceRequestRepository>(),
    ),
  );
  // *** END NURSE HOME BLOC ***

  // Active Service Feature
  sl.registerFactory(() => ActiveServiceBloc(activeServiceRepository: sl()));
  sl.registerLazySingleton<ActiveServiceRepository>(
        () => ActiveServiceRepositoryImpl(
      firestore: sl(),
      firebaseFunctions: sl(),
    ),
  );

  // History Feature
  sl.registerFactory(() => HistoryBloc(historyRepository: sl()));
  sl.registerLazySingleton<HistoryRepository>(
        () => HistoryRepositoryImpl(remoteDataSource: sl()),
  );

  // Profile Feature
  sl.registerFactory(() => ProfileBloc(profileRepository: sl()));
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );


  // Register FirebaseAuth instance
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  // Register Firestore instance
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  // FirebaseFunctions.instanceFor(region: 'your-region')
  sl.registerLazySingleton(() => FirebaseFunctions.instance);

  // Use cases
  // Register as LazySingleton because we typically only need one instance
  // of a use case, created the first time it's requested.
  // sl.registerLazySingleton(() => LoginUser(repository: sl())); // Uncomment later

  // Repository
  // Register the implementation (AuthRepositoryImpl) but specify the
  // abstract type (AuthRepository) so dependant classes don't rely
  // on the concrete implementation. Use LazySingleton.
  // sl.registerLazySingleton<AuthRepository>( // Uncomment later
  //   () => AuthRepositoryImpl(remoteDataSource: sl()),
  // );


  // Nurse Repository
  sl.registerLazySingleton<NurseRepository>(
    () => NurseRepositoryImpl(firestore: sl()),
  );
  // *** NEW: Register AuthRepository ***
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Register Nurse Service Request Repository
  sl.registerLazySingleton<NurseServiceRequestRepository>( // Register Interface
        () => NurseServiceRequestRepositoryImpl(remoteDataSource: sl()), // Provide Implementation (might need firebaseFunctions for callable)
  );
  // Data sources
  // Register the remote data source implementation. Use LazySingleton.
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<ActiveServiceRemoteDataSource>(
    () => ActiveServiceRemoteDataSourceImpl(firestore: sl(), firebaseFunctions: sl()),
  );
  sl.registerLazySingleton<NurseRemoteDataSource>(
    () => NurseRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<NurseServiceRequestRemoteDataSource>(
    () => NurseServiceRequestRemoteDataSourceImpl(firestore: sl(), firebaseFunctions: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firestore: sl()),
  );


  // --- Core / External ---

  // External Packages
  // Register Dio as a LazySingleton so only one instance is created
  // when it's first needed for making HTTP calls.

  // Register other core components like NetworkInfo, etc. later if needed
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));

}