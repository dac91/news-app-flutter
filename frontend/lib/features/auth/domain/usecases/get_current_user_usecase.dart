import 'package:news_app_clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repository/auth_repository.dart';

/// Synchronous use case that returns the currently authenticated user.
///
/// Does not extend [UseCase] because it is synchronous — checking cached
/// auth state does not require a Future.
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  UserEntity? call() {
    return _repository.getCurrentUser();
  }
}
