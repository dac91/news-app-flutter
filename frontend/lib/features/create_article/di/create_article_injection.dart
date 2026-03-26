import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/article_data_sources.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/firestore_article_data_source_impl.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/storage_article_data_source_impl.dart';
import 'package:news_app_clean_architecture/features/create_article/data/repository/create_article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/get_articles_by_author_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/update_article_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/upload_article_image_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_cubit.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/my_articles_cubit.dart';

/// Registers all create-article feature dependencies.
void registerCreateArticleModule(GetIt sl) {
  // Data Sources
  sl.registerSingleton<FirestoreArticleDataSource>(
    FirestoreArticleDataSourceImpl(sl()),
  );

  sl.registerSingleton<StorageArticleDataSource>(
    StorageArticleDataSourceImpl(sl()),
  );

  // Repository
  sl.registerSingleton<CreateArticleRepository>(
    CreateArticleRepositoryImpl(sl(), sl()),
  );

  // Use Cases
  sl.registerSingleton<CreateArticleUseCase>(
    CreateArticleUseCase(sl()),
  );

  sl.registerSingleton<UploadArticleImageUseCase>(
    UploadArticleImageUseCase(sl()),
  );

  sl.registerSingleton<UpdateArticleUseCase>(
    UpdateArticleUseCase(sl()),
  );

  sl.registerSingleton<GetArticlesByAuthorUseCase>(
    GetArticlesByAuthorUseCase(sl()),
  );

  // Cubit (factory — new instance per screen)
  sl.registerFactory<CreateArticleCubit>(
    () => CreateArticleCubit(
      uploadImageUseCase: sl(),
      createArticleUseCase: sl(),
      updateArticleUseCase: sl(),
    ),
  );

  // My Articles cubit (factory — new per screen instance)
  sl.registerFactory<MyArticlesCubit>(
    () => MyArticlesCubit(
      getArticlesByAuthorUseCase: sl(),
    ),
  );
}
