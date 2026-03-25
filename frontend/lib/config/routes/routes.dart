import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/create_article/presentation/cubit/create_article_cubit.dart';
import '../../features/create_article/presentation/screens/create_article_page.dart';
import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/screens/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/screens/home/daily_news.dart';
import '../../features/daily_news/presentation/screens/saved_article/saved_article.dart';
import '../../injection_container.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const DailyNews());

      case '/ArticleDetails':
        return _materialRoute(
          ArticleDetailsView(article: settings.arguments as ArticleEntity),
        );

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());

      case '/CreateArticle':
        return _materialRoute(
          BlocProvider(
            create: (_) => sl<CreateArticleCubit>(),
            child: const CreateArticlePage(),
          ),
        );

      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
