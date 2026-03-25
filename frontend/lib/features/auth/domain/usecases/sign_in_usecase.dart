import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/params/sign_in_params.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repository/auth_repository.dart';

/// Use case for signing in a user with email and password.
class SignInUseCase implements UseCase<DataState<UserEntity>, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call({SignInParams? params}) {
    if (params == null) {
      throw ArgumentError('SignInParams cannot be null');
    }
    return _repository.signIn(params);
  }
}
