import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:news_app_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:news_app_clean_architecture/features/auth/data/repository/auth_repository_impl.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';

class MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockFirebaseAuthDataSource mockDataSource;

  const tUserModel = UserModel(
    uid: 'uid-123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  const tSignInParams = SignInParams(
    email: 'test@example.com',
    password: 'password123',
  );

  const tSignUpParams = SignUpParams(
    email: 'test@example.com',
    password: 'password123',
    displayName: 'Test User',
  );

  setUp(() {
    mockDataSource = MockFirebaseAuthDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('signIn', () {
    test('returns DataSuccess with UserEntity on successful sign-in', () async {
      when(() => mockDataSource.signInWithEmailAndPassword(
            any(),
            any(),
          )).thenAnswer((_) async => tUserModel);

      final result = await repository.signIn(tSignInParams);

      expect(result, isA<DataSuccess<UserEntity>>());
      expect(result.data!.uid, equals('uid-123'));
      expect(result.data!.email, equals('test@example.com'));
      verify(() => mockDataSource.signInWithEmailAndPassword(
            'test@example.com',
            'password123',
          )).called(1);
    });

    test('returns DataFailed when data source throws AppException', () async {
      when(() => mockDataSource.signInWithEmailAndPassword(any(), any()))
          .thenThrow(const AppException(
        message: 'Invalid credentials',
        identifier: 'signIn',
      ));

      final result = await repository.signIn(tSignInParams);

      expect(result, isA<DataFailed<UserEntity>>());
      expect(result.error!.message, equals('Invalid credentials'));
    });

    test('returns DataFailed when data source throws generic exception',
        () async {
      when(() => mockDataSource.signInWithEmailAndPassword(any(), any()))
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.signIn(tSignInParams);

      expect(result, isA<DataFailed<UserEntity>>());
      expect(result.error!.identifier, equals('AuthRepository.signIn'));
    });
  });

  group('signUp', () {
    test('returns DataSuccess with UserEntity on successful sign-up', () async {
      when(() => mockDataSource.createUserWithEmailAndPassword(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => tUserModel);

      final result = await repository.signUp(tSignUpParams);

      expect(result, isA<DataSuccess<UserEntity>>());
      expect(result.data!.uid, equals('uid-123'));
      expect(result.data!.displayName, equals('Test User'));
      verify(() => mockDataSource.createUserWithEmailAndPassword(
            'test@example.com',
            'password123',
            'Test User',
          )).called(1);
    });

    test('returns DataFailed when data source throws AppException', () async {
      when(() => mockDataSource.createUserWithEmailAndPassword(
            any(),
            any(),
            any(),
          )).thenThrow(const AppException(
        message: 'Email already in use',
        identifier: 'signUp',
      ));

      final result = await repository.signUp(tSignUpParams);

      expect(result, isA<DataFailed<UserEntity>>());
      expect(result.error!.message, equals('Email already in use'));
    });

    test('returns DataFailed when data source throws generic exception',
        () async {
      when(() => mockDataSource.createUserWithEmailAndPassword(
            any(),
            any(),
            any(),
          )).thenThrow(Exception('Network error'));

      final result = await repository.signUp(tSignUpParams);

      expect(result, isA<DataFailed<UserEntity>>());
      expect(result.error!.identifier, equals('AuthRepository.signUp'));
    });
  });

  group('signOut', () {
    test('returns DataSuccess on successful sign-out', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, isA<DataSuccess<void>>());
      verify(() => mockDataSource.signOut()).called(1);
    });

    test('returns DataFailed when sign-out throws', () async {
      when(() => mockDataSource.signOut())
          .thenThrow(Exception('Sign out failed'));

      final result = await repository.signOut();

      expect(result, isA<DataFailed<void>>());
      expect(result.error!.identifier, equals('AuthRepository.signOut'));
    });
  });

  group('getCurrentUser', () {
    test('returns UserEntity when user is authenticated', () {
      when(() => mockDataSource.getCurrentUser()).thenReturn(tUserModel);

      final user = repository.getCurrentUser();

      expect(user, isA<UserEntity>());
      expect(user!.uid, equals('uid-123'));
    });

    test('returns null when no user is authenticated', () {
      when(() => mockDataSource.getCurrentUser()).thenReturn(null);

      final user = repository.getCurrentUser();

      expect(user, isNull);
    });
  });

  group('authStateChanges', () {
    test('maps UserModel stream to UserEntity stream', () {
      when(() => mockDataSource.authStateChanges)
          .thenAnswer((_) => Stream.value(tUserModel));

      final stream = repository.authStateChanges;

      expect(stream, emits(isA<UserEntity>()));
    });

    test('emits null when data source emits null', () {
      when(() => mockDataSource.authStateChanges)
          .thenAnswer((_) => Stream.value(null));

      final stream = repository.authStateChanges;

      expect(stream, emits(isNull));
    });
  });
}
