import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_state.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockGetCurrentUserUseCase extends Mock
    implements GetCurrentUserUseCase {}

void main() {
  late MockSignInUseCase mockSignIn;
  late MockSignUpUseCase mockSignUp;
  late MockSignOutUseCase mockSignOut;
  late MockGetCurrentUserUseCase mockGetCurrentUser;
  late StreamController<UserEntity?> authStreamController;

  setUpAll(() {
    registerFallbackValue(
      const SignInParams(email: '', password: ''),
    );
    registerFallbackValue(
      const SignUpParams(email: '', password: '', displayName: ''),
    );
  });

  setUp(() {
    mockSignIn = MockSignInUseCase();
    mockSignUp = MockSignUpUseCase();
    mockSignOut = MockSignOutUseCase();
    mockGetCurrentUser = MockGetCurrentUserUseCase();
    authStreamController = StreamController<UserEntity?>();
  });

  tearDown(() {
    authStreamController.close();
  });

  AuthCubit buildCubit() {
    return AuthCubit(
      signInUseCase: mockSignIn,
      signUpUseCase: mockSignUp,
      signOutUseCase: mockSignOut,
      getCurrentUserUseCase: mockGetCurrentUser,
      authStateChanges: authStreamController.stream,
    );
  }

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      final cubit = buildCubit();
      expect(cubit.state, isA<AuthInitial>());
      cubit.close();
    });

    test('signIn emits [AuthLoading, AuthAuthenticated] on success', () async {
      when(() => mockSignIn.call(params: any(named: 'params'))).thenAnswer(
        (_) async => const DataSuccess(
          UserEntity(uid: '1', email: 'a@b.com', displayName: 'Test'),
        ),
      );

      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.signIn('a@b.com', '123456');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthAuthenticated>());
      expect((states[1] as AuthAuthenticated).user.uid, '1');

      await sub.cancel();
      await cubit.close();
    });

    test('signIn emits [AuthLoading, AuthError] on failure', () async {
      when(() => mockSignIn.call(params: any(named: 'params'))).thenAnswer(
        (_) async => const DataFailed(
          AppException(message: 'Invalid credentials'),
        ),
      );

      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.signIn('a@b.com', 'wrong');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthError>());
      expect((states[1] as AuthError).message, 'Invalid credentials');

      await sub.cancel();
      await cubit.close();
    });

    test('signUp emits [AuthLoading, AuthAuthenticated] on success', () async {
      when(() => mockSignUp.call(params: any(named: 'params'))).thenAnswer(
        (_) async => const DataSuccess(
          UserEntity(uid: '2', email: 'new@b.com', displayName: 'New'),
        ),
      );

      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.signUp('new@b.com', '123456', 'New');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthAuthenticated>());

      await sub.cancel();
      await cubit.close();
    });

    test('signUp emits [AuthLoading, AuthError] on failure', () async {
      when(() => mockSignUp.call(params: any(named: 'params'))).thenAnswer(
        (_) async => const DataFailed(
          AppException(message: 'Email already in use'),
        ),
      );

      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.signUp('a@b.com', '123', 'Test');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthError>());

      await sub.cancel();
      await cubit.close();
    });

    test('signOut emits AuthUnauthenticated', () async {
      when(() => mockSignOut.call()).thenAnswer(
        (_) async => const DataSuccess(null),
      );

      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.signOut();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 1);
      expect(states[0], isA<AuthUnauthenticated>());

      await sub.cancel();
      await cubit.close();
    });

    test('checkAuthStatus emits AuthAuthenticated when user exists', () async {
      when(() => mockGetCurrentUser.call()).thenReturn(
        const UserEntity(uid: '1', email: 'a@b.com'),
      );

      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      cubit.checkAuthStatus();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 1);
      expect(states[0], isA<AuthAuthenticated>());

      await sub.cancel();
      await cubit.close();
    });

    test('checkAuthStatus emits AuthUnauthenticated when no user', () async {
      when(() => mockGetCurrentUser.call()).thenReturn(null);

      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      cubit.checkAuthStatus();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 1);
      expect(states[0], isA<AuthUnauthenticated>());

      await sub.cancel();
      await cubit.close();
    });

    test('init listens to auth state changes', () async {
      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      cubit.init();
      authStreamController.add(
        const UserEntity(uid: '1', email: 'a@b.com'),
      );
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 1);
      expect(states[0], isA<AuthAuthenticated>());

      await sub.cancel();
      await cubit.close();
    });

    test('init emits AuthUnauthenticated when stream emits null', () async {
      final cubit = buildCubit();
      final states = <AuthState>[];
      final sub = cubit.stream.listen(states.add);

      cubit.init();
      authStreamController.add(null);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 1);
      expect(states[0], isA<AuthUnauthenticated>());

      await sub.cancel();
      await cubit.close();
    });

    test('AuthError state contains message', () {
      const error = AuthError('Something went wrong');
      expect(error.message, 'Something went wrong');
      expect(error.props, ['Something went wrong']);
    });

    test('AuthAuthenticated state contains user', () {
      const user = UserEntity(uid: '1');
      const state = AuthAuthenticated(user);
      expect(state.user, user);
      expect(state.props, [user]);
    });
  });
}
