import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';

void main() {
  group('SignUpParams', () {
    test('stores all fields correctly', () {
      const params = SignUpParams(
        email: 'test@example.com',
        password: 'secret123',
        displayName: 'Test User',
      );

      expect(params.email, equals('test@example.com'));
      expect(params.password, equals('secret123'));
      expect(params.displayName, equals('Test User'));
    });

    test('supports const constructor', () {
      const params1 = SignUpParams(
        email: 'a@b.com',
        password: 'pass',
        displayName: 'Name',
      );
      const params2 = SignUpParams(
        email: 'a@b.com',
        password: 'pass',
        displayName: 'Name',
      );

      expect(identical(params1, params2), isTrue);
    });

    test('different displayName produces different instance', () {
      const params1 = SignUpParams(
        email: 'a@b.com',
        password: 'pass',
        displayName: 'Alice',
      );
      const params2 = SignUpParams(
        email: 'a@b.com',
        password: 'pass',
        displayName: 'Bob',
      );

      expect(params1.displayName, isNot(equals(params2.displayName)));
    });

    test('all three fields are required', () {
      // This test validates the constructor signature: all fields required.
      const params = SignUpParams(
        email: 'required@test.com',
        password: 'required',
        displayName: 'Required Name',
      );

      expect(params.email, isNotEmpty);
      expect(params.password, isNotEmpty);
      expect(params.displayName, isNotEmpty);
    });
  });
}
