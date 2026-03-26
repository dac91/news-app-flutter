import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/core/di/provider_module.dart';
import 'package:news_app_clean_architecture/features/ai_insight/di/ai_insight_injection.dart';
import 'package:news_app_clean_architecture/features/auth/di/auth_injection.dart';
import 'package:news_app_clean_architecture/features/create_article/di/create_article_injection.dart';
import 'package:news_app_clean_architecture/features/daily_news/di/daily_news_injection.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core providers (Firebase, Dio, Connectivity, etc.)
  await registerProviderModule(sl);

  // Feature modules
  registerAuthModule(sl);
  registerDailyNewsModule(sl);
  registerCreateArticleModule(sl);
  registerAiInsightModule(sl);
}
