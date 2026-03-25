import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    test('extends UserEntity', () {
      const model = UserModel(uid: '1', email: 'a@b.com', displayName: 'A');
      expect(model, isA<UserEntity>());
    });

    test('fromFirebaseUser creates model with all fields', () {
      final model = UserModel.fromFirebaseUser(
        uid: 'uid-123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(model.uid, 'uid-123');
      expect(model.email, 'test@example.com');
      expect(model.displayName, 'Test User');
    });

    test('fromFirebaseUser handles null optional fields', () {
      final model = UserModel.fromFirebaseUser(uid: 'uid-456');

      expect(model.uid, 'uid-456');
      expect(model.email, isNull);
      expect(model.displayName, isNull);
    });

    test('toEntity converts to UserEntity with all fields preserved', () {
      const model = UserModel(
        uid: 'uid-789',
        email: 'user@test.com',
        displayName: 'Jane',
      );

      final entity = model.toEntity();

      expect(entity, isA<UserEntity>());
      expect(entity.uid, 'uid-789');
      expect(entity.email, 'user@test.com');
      expect(entity.displayName, 'Jane');
    });

    test('supports value equality inherited from UserEntity', () {
      const model1 = UserModel(uid: '1', email: 'a@b.com');
      const model2 = UserModel(uid: '1', email: 'a@b.com');

      expect(model1, equals(model2));
    });
  });
}
