import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';

/// Data model extending [UserEntity] with Firebase-specific conversion logic.
///
/// Bridges the Firebase `User` object and the domain [UserEntity].
class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    String? email,
    String? displayName,
  }) : super(uid: uid, email: email, displayName: displayName);

  /// Creates a [UserModel] from a Firebase User-like map.
  factory UserModel.fromFirebaseUser({
    required String uid,
    String? email,
    String? displayName,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }

  /// Converts this model to a domain [UserEntity].
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }
}
