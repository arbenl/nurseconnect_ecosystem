import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nurseconnect/features/auth/presentation/bloc/login_bloc.dart';
import 'package:nurseconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurseconnect_shared/models/user_role.dart';
import 'package:dartz/dartz.dart';

// Mock classes for dependencies
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late LoginBloc loginBloc;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockAuthRepository = MockAuthRepository();
    loginBloc = LoginBloc(
      firebaseAuth: mockFirebaseAuth,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc', () {
    test('initial state is LoginInitial', () {
      expect(loginBloc.state, LoginInitial());
    });

    blocTest<
        LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccessNurse] when login is successful and user is a nurse',
      build: () {
        final mockUser = MockUser();
        when(mockUser.uid).thenReturn('testUid');

        final mockUserCredential = MockUserCredential();
        when(mockUserCredential.user).thenReturn(mockUser);

        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: argThat(isA<String>()),
          password: argThat(isA<String>()),
        )).thenAnswer((_) async => mockUserCredential);

        when(mockAuthRepository.getUserRole(anyNamed('uid')))
            .thenAnswer((_) async => const Right(UserRole.nurse));

        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginButtonPressed(email: 'test@nurse.com', password: 'password')),
      expect: () => [
        LoginLoading(),
        LoginSuccessNurse(),
      ],
    );
  });
}