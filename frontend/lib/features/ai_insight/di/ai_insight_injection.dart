import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/data_sources/ai_insight_data_sources.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/data_sources/firestore_insight_cache_impl.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/data_sources/gemini_data_source_impl.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/repository/ai_insight_repository_impl.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/repository/ai_insight_repository.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/usecases/get_article_insight_usecase.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_cubit.dart';

/// Registers all AI-insight feature dependencies.
void registerAiInsightModule(GetIt sl) {
  // Gemini AI Model
  sl.registerSingleton<GenerativeModel>(
    GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: geminiAPIKey,
    ),
  );

  // Data Sources
  sl.registerSingleton<GeminiDataSource>(
    GeminiDataSourceImpl(sl()),
  );

  sl.registerSingleton<InsightCacheDataSource>(
    FirestoreInsightCacheImpl(sl()),
  );

  // Repository
  sl.registerSingleton<AiInsightRepository>(
    AiInsightRepositoryImpl(sl(), sl()),
  );

  // Use Cases
  sl.registerSingleton<GetArticleInsightUseCase>(
    GetArticleInsightUseCase(sl()),
  );

  // Cubit (factory — new instance per article detail screen)
  sl.registerFactory<AiInsightCubit>(
    () => AiInsightCubit(
      getArticleInsightUseCase: sl(),
    ),
  );
}
