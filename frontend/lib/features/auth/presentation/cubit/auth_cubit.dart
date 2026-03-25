import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_state.dart';

/// Cubit managing authentication state throughout the app.
///
/// Listens to Firebase Auth state changes and exposes sign in, sign up,
/// and sign out operations through use cases.
class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final Stream<UserEntity?> _authStateChanges;

  StreamSubscription<UserEntity?>? _authSubscription;

  AuthCubit({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required Stream<UserEntity?> authStateChanges,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authStateChanges = authStateChanges,
        super(const AuthInitial());

  /// Starts listening to auth state changes from Firebase.
  void init() {
    _authSubscription = _authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  /// Checks the current auth state synchronously.
  void checkAuthStatus() {
    final user = _getCurrentUserUseCase();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Signs in with email and password.
  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    final result = await _signInUseCase.call(
      params: SignInParams(email: email, password: password),
    );
    if (result is DataSuccess<UserEntity>) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error?.message ?? 'Sign in failed'));
    }
  }

  /// Signs up with email, password, and display name.
  Future<void> signUp(String email, String password, String displayName) async {
    emit(const AuthLoading());
    final result = await _signUpUseCase.call(
      params: SignUpParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
    if (result is DataSuccess<UserEntity>) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error?.message ?? 'Sign up failed'));
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _signOutUseCase.call();
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
