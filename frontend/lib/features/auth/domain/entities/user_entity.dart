import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
///
/// Contains only the fields the app needs from the authentication provider.
/// The domain layer remains pure Dart with no Firebase dependency.
class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [uid, email, displayName];
}
