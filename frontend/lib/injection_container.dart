import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/services/connectivity_service.dart';
import 'package:news_app_clean_architecture/core/services/draft_service.dart';
import 'package:news_app_clean_architecture/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:news_app_clean_architecture/features/auth/data/data_sources/firebase_auth_data_source_impl.dart';
import 'package:news_app_clean_architecture/features/auth/data/repository/auth_repository_impl.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_cubit.dart';
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
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);
  
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Firebase
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  // Connectivity
  sl.registerSingleton<ConnectivityService>(ConnectivityService());

  // Draft Service
  sl.registerSingleton<DraftService>(DraftService());

  // --- auth feature ---

  // Data Sources
  sl.registerSingleton<FirebaseAuthDataSource>(
    FirebaseAuthDataSourceImpl(sl()),
  );

  // Repository
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerSingleton<SignInUseCase>(SignInUseCase(sl()));
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase(sl()));
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase(sl()));
  sl.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase(sl()));

  // Cubit (singleton — lives for the entire app lifecycle)
  sl.registerSingleton<AuthCubit>(
    AuthCubit(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authStateChanges: sl<AuthRepository>().authStateChanges,
    )..init(),
  );

  // --- daily_news feature ---

  // Dependencies
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(),sl(),sl())
  );
  
  //UseCases
  sl.registerSingleton<GetArticleUseCase>(
    GetArticleUseCase(sl())
  );

  sl.registerSingleton<GetSavedArticleUseCase>(
    GetSavedArticleUseCase(sl())
  );

  sl.registerSingleton<SaveArticleUseCase>(
    SaveArticleUseCase(sl())
  );
  
  sl.registerSingleton<RemoveArticleUseCase>(
    RemoveArticleUseCase(sl())
  );


  //Blocs
  sl.registerFactory<RemoteArticlesBloc>(
    ()=> RemoteArticlesBloc(sl())
  );

  sl.registerFactory<LocalArticleBloc>(
    ()=> LocalArticleBloc(sl(),sl(),sl())
  );

  // --- create_article feature ---

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
