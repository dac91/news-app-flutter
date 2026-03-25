import 'package:news_app_clean_architecture/features/auth/data/models/user_model.dart';

/// Abstract data source contract for Firebase Authentication operations.
///
/// Implemented by [FirebaseAuthDataSourceImpl] which wraps the actual
/// Firebase Auth SDK calls.
abstract class FirebaseAuthDataSource {
  /// Signs in with email and password. Returns a [UserModel].
  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  /// Creates a new account with email, password, and display name.
  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  );

  /// Signs out the current user.
  Future<void> signOut();

  /// Returns the currently authenticated user, or null.
  UserModel? getCurrentUser();

  /// Stream of auth state changes mapped to [UserModel].
  Stream<UserModel?> get authStateChanges;
}
