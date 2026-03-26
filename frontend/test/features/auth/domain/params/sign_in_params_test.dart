import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';

void main() {
  group('SignInParams', () {
    test('stores email and password correctly', () {
      const params = SignInParams(
        email: 'test@example.com',
        password: 'secret123',
      );

      expect(params.email, equals('test@example.com'));
      expect(params.password, equals('secret123'));
    });

    test('supports const constructor', () {
      const params1 = SignInParams(
        email: 'a@b.com',
        password: 'pass',
      );
      const params2 = SignInParams(
        email: 'a@b.com',
        password: 'pass',
      );

      // const instances with same values are identical
      expect(identical(params1, params2), isTrue);
    });

    test('different email produces different instance', () {
      const params1 = SignInParams(
        email: 'a@b.com',
        password: 'pass',
      );
      const params2 = SignInParams(
        email: 'c@d.com',
        password: 'pass',
      );

      expect(params1.email, isNot(equals(params2.email)));
    });

    test('different password produces different instance', () {
      const params1 = SignInParams(
        email: 'a@b.com',
        password: 'pass1',
      );
      const params2 = SignInParams(
        email: 'a@b.com',
        password: 'pass2',
      );

      expect(params1.password, isNot(equals(params2.password)));
    });
  });
}
