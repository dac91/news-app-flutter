import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('supports value equality via Equatable', () {
      const user1 = UserEntity(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );
      const user2 = UserEntity(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(user1, equals(user2));
    });

    test('entities with different uids are not equal', () {
      const user1 = UserEntity(uid: '123', email: 'a@b.com');
      const user2 = UserEntity(uid: '456', email: 'a@b.com');

      expect(user1, isNot(equals(user2)));
    });

    test('email and displayName are nullable', () {
      const user = UserEntity(uid: '123');

      expect(user.email, isNull);
      expect(user.displayName, isNull);
    });

    test('props contains all fields', () {
      const user = UserEntity(
        uid: 'uid-1',
        email: 'user@example.com',
        displayName: 'John',
      );

      expect(user.props, ['uid-1', 'user@example.com', 'John']);
    });
  });
}
