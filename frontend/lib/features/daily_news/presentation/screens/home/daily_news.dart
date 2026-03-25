import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/theme_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/shared/widgets/article_shimmer_list.dart';
import 'package:news_app_clean_architecture/shared/widgets/error_retry_widget.dart';

import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPage();
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Daily News'),
      actions: [
        GestureDetector(
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(context.watch<ThemeCubit>().icon),
          ),
        ),
        GestureDetector(
          onTap: () => _onShowSavedArticlesViewTapped(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.bookmark),
          ),
        ),
      ],
    );
  }

  Widget _buildPage() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesLoading) {
          return Scaffold(
            appBar: _buildAppbar(context),
            body: const ArticleShimmerList(),
          );
        }
        if (state is RemoteArticlesError) {
          return Scaffold(
            appBar: _buildAppbar(context),
            body: ErrorRetryWidget(
              onRetry: () => _onRetry(context),
            ),
          );
        }
        if (state is RemoteArticlesDone) {
          return _buildArticlesPage(context, state.articles ?? []);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildArticlesPage(
      BuildContext context, List<ArticleEntity> articles) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: RefreshIndicator(
        onRefresh: () async => _onRetry(context),
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return ArticleWidget(
              article: articles[index],
              onArticlePressed: (article) =>
                  _onArticlePressed(context, article),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onCreateArticleTapped(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onRetry(BuildContext context) {
    context.read<RemoteArticlesBloc>().add(const GetArticles());
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }

  void _onCreateArticleTapped(BuildContext context) {
    Navigator.pushNamed(context, '/CreateArticle');
  }
}
