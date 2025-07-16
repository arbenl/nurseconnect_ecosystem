// lib/core/dependency_injection/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:nurseconnect_patient/features/auth/domain/repositories/user_repository.dart';
import 'package:nurseconnect_patient/features/auth/data/repositories/user_repository_impl.dart';
import 'package:nurseconnect_patient/features/home/domain/repositories/service_request_repository.dart';
import 'package:nurseconnect_patient/features/home/data/repositories/service_request_repository_impl.dart';

// Import feature dependencies when they are created
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/auth/presentation/bloc/registration_bloc.dart'; // Patient Registration Bloc
// *** Add Auth Repository Imports ***

import 'package:nurseconnect_patient/features/auth/data/repositories/patient_auth_repository_impl.dart';

// Import nurse repo if not already


// --- End Auth Feature Imports ---
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import 'package:nurseconnect_patient/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:nurseconnect_patient/features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nurseconnect_patient/features/select_service/data/repositories/nursing_service_repository_impl.dart';
import 'package:nurseconnect_patient/features/select_service/domain/repositories/nursing_service_repository.dart';
import 'package:nurseconnect_patient/features/select_service/presentation/bloc/select_service_bloc.dart';
import 'package:nurseconnect_patient/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:nurseconnect_patient/features/payment/domain/repositories/payment_repository.dart';
import 'package:nurseconnect_patient/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:nurseconnect_patient/features/auth/domain/repositories/patient_auth_repository.dart';
import 'package:nurseconnect_patient/features/auth/data/datasources/patient_auth_remote_data_source.dart';
import 'package:nurseconnect_patient/features/auth/data/datasources/patient_auth_remote_data_source_impl.dart';
import 'package:nurseconnect_patient/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:nurseconnect_patient/features/auth/data/datasources/user_remote_data_source_impl.dart';
import 'package:nurseconnect_patient/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nurseconnect_patient/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:nurseconnect_patient/features/history/data/datasources/history_remote_data_source.dart';
import 'package:nurseconnect_patient/features/history/data/datasources/history_remote_data_source_impl.dart';
import 'package:nurseconnect_patient/features/home/data/datasources/service_request_remote_data_source.dart';
import 'package:nurseconnect_patient/features/home/data/datasources/service_request_remote_data_source_impl.dart';
import 'package:nurseconnect_patient/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:nurseconnect_patient/features/payment/data/datasources/payment_remote_data_source_impl.dart';
import 'package:nurseconnect_patient/features/select_service/data/datasources/nursing_service_remote_data_source.dart';
import 'package:nurseconnect_patient/features/select_service/data/datasources/nursing_service_remote_data_source_impl.dart';


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
      patientAuthRepository: sl(), // Inject AuthRepository instead of Firestore
      firebaseFunctions: sl(),
    ),
  );

  // Bloc (Registration)
  sl.registerFactory(
        () => RegistrationBloc(
      firebaseAuth: sl(), // Keep this
      firestore: sl(),    // Inject Firestore instance
      // registerUser: sl(), // Keep this commented
    ),
  );

  // Bloc (Home)
  sl.registerFactory(
        () => HomeBloc(
      // Fetch instances from GetIt and pass them to the constructor
      userRepository: sl<UserRepository>(),
      serviceRequestRepository: sl<ServiceRequestRepository>(),
      firestore: sl(),
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

  // Select Service Feature
  sl.registerFactory(() => SelectServiceBloc(nursingServiceRepository: sl()));
  sl.registerLazySingleton<NursingServiceRepository>(
        () => NursingServiceRepositoryImpl(remoteDataSource: sl()),
  );

  // Payment Feature
  sl.registerFactory(() => PaymentBloc(paymentRepository: sl()));
  sl.registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );

  // Register FirebaseAuth instance
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  // Register Firestore instance
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  // FirebaseFunctions.instanceFor(region: 'your-region')
  sl.registerLazySingleton(() => FirebaseFunctions.instance);
  // Register FirebaseStorage instance
  sl.registerLazySingleton(() => FirebaseStorage.instance);

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

  // Repository (User) - Register implementation for the interface
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(remoteDataSource: sl()),
  );


  // *** NEW: Register AuthRepository ***
  sl.registerLazySingleton<PatientAuthRepository>(
    () => PatientAuthRepositoryImpl(remoteDataSource: sl()),
  ); // Added missing parenthesis

  sl.registerLazySingleton<ServiceRequestRepository>( // Register Interface
        () => ServiceRequestRepositoryImpl(remoteDataSource: sl()), // Provide Implementation
  );
  // Data sources
  // Register the remote data source implementation. Use LazySingleton.
  sl.registerLazySingleton<PatientAuthRemoteDataSource>(
    () => PatientAuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firestore: sl(), auth: sl(), functions: sl(), storage: sl()),
  );
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ServiceRequestRemoteDataSource>(
    () => ServiceRequestRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<NursingServiceRemoteDataSource>(
    () => NursingServiceRemoteDataSourceImpl(firestore: sl()),
  );


  // --- Core / External ---

  // External Packages
  // Register Dio as a LazySingleton so only one instance is created
  // when it's first needed for making HTTP calls.

  // Register other core components like NetworkInfo, etc. later if needed
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));

}