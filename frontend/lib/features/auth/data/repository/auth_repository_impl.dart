import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_up_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repository/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// The data source layer handles Firebase-specific exception mapping
/// (converting [FirebaseAuthException] → [AppException]). This repository
/// catches those [AppException]s and wraps them in [DataFailed], keeping
/// the data layer free of Firebase imports at the repository level (AV 1.2.4).
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
    } on AppException catch (e) {
      return DataFailed(e);
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
    } on AppException catch (e) {
      return DataFailed(e);
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
}
