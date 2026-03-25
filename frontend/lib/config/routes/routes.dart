import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/create_article/domain/entities/firebase_article_entity.dart';
import '../../features/create_article/presentation/cubit/create_article_cubit.dart';
import '../../features/create_article/presentation/cubit/my_articles_cubit.dart';
import '../../features/create_article/presentation/screens/create_article_page.dart';
import '../../features/create_article/presentation/screens/my_articles_screen.dart';
import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/screens/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/screens/saved_article/saved_article.dart';
import '../../injection_container.dart';
import '../../shared/widgets/main_navigation.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const MainNavigation());

      case '/Login':
        return _materialRoute(const LoginScreen());

      case '/SignUp':
        return _materialRoute(const SignUpScreen());

      case '/ArticleDetails':
        return _materialRoute(
          ArticleDetailsView(article: settings.arguments as ArticleEntity),
        );

      case '/SavedArticles':
        return _materialRoute(const SavedArticles(showBackButton: true));

      case '/CreateArticle':
        return _materialRoute(
          BlocProvider(
            create: (_) => sl<CreateArticleCubit>(),
            child: const CreateArticlePage(),
          ),
        );

      case '/EditArticle':
        return _materialRoute(
          BlocProvider(
            create: (_) => sl<CreateArticleCubit>(),
            child: CreateArticlePage(
              articleToEdit: settings.arguments as FirebaseArticleEntity,
            ),
          ),
        );

      case '/MyArticles':
        return _materialRoute(
          BlocProvider(
            create: (_) => sl<MyArticlesCubit>(),
            child: MyArticlesScreen(
              authorName: settings.arguments as String,
            ),
          ),
        );

      default:
        return _materialRoute(const MainNavigation());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
