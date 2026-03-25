import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/get_current_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeSignInParams extends Fake implements SignInParams {}

class FakeSignUpParams extends Fake implements SignUpParams {}

void main() {
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeSignInParams());
    registerFallbackValue(FakeSignUpParams());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('SignInUseCase', () {
    late SignInUseCase useCase;

    setUp(() {
      useCase = SignInUseCase(mockRepository);
    });

    test('returns DataSuccess with UserEntity on success', () async {
      const params = SignInParams(email: 'a@b.com', password: '123456');
      const user = UserEntity(uid: '1', email: 'a@b.com', displayName: 'A');
      when(() => mockRepository.signIn(any()))
          .thenAnswer((_) async => const DataSuccess(user));

      final result = await useCase.call(params: params);

      expect(result, isA<DataSuccess<UserEntity>>());
      expect(result.data?.uid, '1');
      verify(() => mockRepository.signIn(any())).called(1);
    });

    test('returns DataFailed with AppException on failure', () async {
      const params = SignInParams(email: 'a@b.com', password: 'wrong');
      when(() => mockRepository.signIn(any())).thenAnswer((_) async =>
          const DataFailed(AppException(message: 'Invalid credentials')));

      final result = await useCase.call(params: params);

      expect(result, isA<DataFailed<UserEntity>>());
      expect(result.error?.message, 'Invalid credentials');
    });

    test('throws ArgumentError when params is null', () {
      expect(
        () => useCase.call(params: null),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('SignUpUseCase', () {
    late SignUpUseCase useCase;

    setUp(() {
      useCase = SignUpUseCase(mockRepository);
    });

    test('returns DataSuccess with UserEntity on success', () async {
      const params = SignUpParams(
        email: 'new@b.com',
        password: '123456',
        displayName: 'New User',
      );
      const user =
          UserEntity(uid: '2', email: 'new@b.com', displayName: 'New User');
      when(() => mockRepository.signUp(any()))
          .thenAnswer((_) async => const DataSuccess(user));

      final result = await useCase.call(params: params);

      expect(result, isA<DataSuccess<UserEntity>>());
      expect(result.data?.displayName, 'New User');
      verify(() => mockRepository.signUp(any())).called(1);
    });

    test('returns DataFailed with AppException on failure', () async {
      const params = SignUpParams(
        email: 'a@b.com',
        password: '123',
        displayName: 'Test',
      );
      when(() => mockRepository.signUp(any())).thenAnswer((_) async =>
          const DataFailed(AppException(message: 'Email already in use')));

      final result = await useCase.call(params: params);

      expect(result, isA<DataFailed<UserEntity>>());
      expect(result.error?.message, 'Email already in use');
    });

    test('throws ArgumentError when params is null', () {
      expect(
        () => useCase.call(params: null),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('SignOutUseCase', () {
    late SignOutUseCase useCase;

    setUp(() {
      useCase = SignOutUseCase(mockRepository);
    });

    test('returns DataSuccess on success', () async {
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const DataSuccess(null));

      final result = await useCase.call();

      expect(result, isA<DataSuccess<void>>());
      verify(() => mockRepository.signOut()).called(1);
    });
  });

  group('GetCurrentUserUseCase', () {
    late GetCurrentUserUseCase useCase;

    setUp(() {
      useCase = GetCurrentUserUseCase(mockRepository);
    });

    test('returns UserEntity when user is signed in', () {
      const user = UserEntity(uid: '1', email: 'a@b.com');
      when(() => mockRepository.getCurrentUser()).thenReturn(user);

      final result = useCase();

      expect(result, user);
    });

    test('returns null when no user is signed in', () {
      when(() => mockRepository.getCurrentUser()).thenReturn(null);

      final result = useCase();

      expect(result, isNull);
    });
  });
}
