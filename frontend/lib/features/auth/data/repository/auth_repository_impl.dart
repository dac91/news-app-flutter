import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repository/auth_repository.dart';

/// Concrete implementation of [AuthRepository] using Firebase Auth.
///
/// Catches [FirebaseAuthException] from the data source and wraps them
/// in [AppException] so the domain and presentation layers remain pure.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<DataState<UserEntity>> signIn(SignInParams params) async {
    try {
      final user = await _dataSource.signInWithEmailAndPassword(
        params.email,
        params.password,
      );
      return DataSuccess(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return DataFailed(AppException(
        message: _mapFirebaseErrorMessage(e.code),
        identifier: 'AuthRepository.signIn',
      ));
    } catch (e) {
      return DataFailed(AppException(
        message: e.toString(),
        identifier: 'AuthRepository.signIn',
      ));
    }
  }

  @override
  Future<DataState<UserEntity>> signUp(SignUpParams params) async {
    try {
      final user = await _dataSource.createUserWithEmailAndPassword(
        params.email,
        params.password,
        params.displayName,
      );
      return DataSuccess(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return DataFailed(AppException(
        message: _mapFirebaseErrorMessage(e.code),
        identifier: 'AuthRepository.signUp',
      ));
    } catch (e) {
      return DataFailed(AppException(
        message: e.toString(),
        identifier: 'AuthRepository.signUp',
      ));
    }
  }

  @override
  Future<DataState<void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(AppException(
        message: e.toString(),
        identifier: 'AuthRepository.signOut',
      ));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    final model = _dataSource.getCurrentUser();
    return model?.toEntity();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _dataSource.authStateChanges.map((model) => model?.toEntity());
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
