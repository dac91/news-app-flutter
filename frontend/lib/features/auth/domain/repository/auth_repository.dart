import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';

/// Abstract repository contract for authentication operations.
///
/// Implemented by [AuthRepositoryImpl] in the data layer.
abstract class AuthRepository {
  /// Signs in a user with email and password.
  Future<DataState<UserEntity>> signIn(SignInParams params);

  /// Registers a new user with email, password, and display name.
  Future<DataState<UserEntity>> signUp(SignUpParams params);

  /// Signs out the currently authenticated user.
  Future<DataState<void>> signOut();

  /// Returns the currently authenticated user, or null if not signed in.
  UserEntity? getCurrentUser();

  /// Stream of authentication state changes.
  Stream<UserEntity?> get authStateChanges;
}
