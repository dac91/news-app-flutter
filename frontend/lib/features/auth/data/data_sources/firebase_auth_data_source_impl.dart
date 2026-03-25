import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:news_app_clean_architecture/features/auth/data/models/user_model.dart';

/// Concrete implementation of [FirebaseAuthDataSource] using Firebase Auth SDK.
///
/// Catches [FirebaseAuthException] and converts it to [AppException] so that
/// the repository and higher layers never import Firebase packages (AV 1.2.4).
class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AppException(
        message: _mapFirebaseErrorMessage(e.code),
        identifier: 'FirebaseAuthDataSource.signIn',
      );
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      // Reload to get updated display name
      await credential.user!.reload();
      final updatedUser = _firebaseAuth.currentUser!;
      return _mapUser(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw AppException(
        message: _mapFirebaseErrorMessage(e.code),
        identifier: 'FirebaseAuthDataSource.signUp',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return _mapUser(user);
    });
  }

  UserModel _mapUser(User user) {
    return UserModel.fromFirebaseUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  /// Maps Firebase Auth error codes to user-friendly messages.
  String _mapFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
