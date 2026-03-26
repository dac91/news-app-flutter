import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/theme_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/shared/widgets/article_shimmer_list.dart';
import 'package:news_app_clean_architecture/shared/widgets/category_chip_bar.dart';
import 'package:news_app_clean_architecture/shared/widgets/error_retry_widget.dart';

import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatefulWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  State<DailyNews> createState() => _DailyNewsState();
}

class _DailyNewsState extends State<DailyNews> {
  String? _selectedCategory;
  bool _isSearching = false;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppbar(context),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _closeSearch,
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search articles...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
        ],
      );
    }

    return AppBar(
      title: const Text('Daily News'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _openSearch,
          tooltip: 'Search',
        ),
        GestureDetector(
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(context.watch<ThemeCubit>().icon),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, RemoteArticlesState state) {
    if (state is RemoteArticlesLoading) {
      return Column(
        children: [
          if (!_isSearching) _buildCategoryBar(),
          const Expanded(child: ArticleShimmerList()),
        ],
      );
    }
    if (state is RemoteArticlesError) {
      return Column(
        children: [
          if (!_isSearching) _buildCategoryBar(),
          Expanded(
            child: ErrorRetryWidget(
              onRetry: () => _onRetry(context),
            ),
          ),
        ],
      );
    }
    if (state is RemoteArticlesDone) {
      return _buildArticlesList(context, state.articles ?? []);
    }
    return const SizedBox();
  }

  Widget _buildCategoryBar() {
    return CategoryChipBar(
      selectedCategory: _selectedCategory,
      onCategorySelected: _onCategorySelected,
    );
  }

  Widget _buildArticlesList(
      BuildContext context, List<ArticleEntity> articles) {
    final blocState = context.watch<RemoteArticlesBloc>().state;
    final isLoadingMore =
        blocState is RemoteArticlesDone && blocState.isLoadingMore;
    final hasReachedMax =
        blocState is RemoteArticlesDone && blocState.hasReachedMax;

    return Column(
      children: [
        if (!_isSearching) _buildCategoryBar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _onRetry(context),
            child: articles.isEmpty
                ? ListView(
                    // Keep scrollable so pull-to-refresh works on empty state
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.article_outlined,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            const SizedBox(height: 16),
                            Text(
                              'No articles found',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.extentAfter < 300 &&
                          !isLoadingMore &&
                          !hasReachedMax) {
                        context
                            .read<RemoteArticlesBloc>()
                            .add(const LoadMoreArticles());
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: articles.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= articles.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                            ),
                          );
                        }
                        return ArticleWidget(
                          article: articles[index],
                          onArticlePressed: (article) =>
                              _onArticlePressed(context, article),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // --- Callbacks ---

  void _onCategorySelected(String? category) {
    setState(() => _selectedCategory = category);
    context.read<RemoteArticlesBloc>().add(
          GetArticles(category: category),
        );
  }

  void _openSearch() {
    setState(() => _isSearching = true);
  }

  void _closeSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() => _isSearching = false);
    // Re-fetch with current category, no query
    context.read<RemoteArticlesBloc>().add(
          GetArticles(category: _selectedCategory),
        );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isEmpty) {
        context.read<RemoteArticlesBloc>().add(
              GetArticles(category: _selectedCategory),
            );
      } else {
        context.read<RemoteArticlesBloc>().add(
              GetArticles(query: value.trim()),
            );
      }
    });
    // Trigger rebuild to show/hide clear button
    setState(() {});
  }

  void _onRetry(BuildContext context) {
    final query = _searchController.text.trim();
    context.read<RemoteArticlesBloc>().add(
          GetArticles(
            category: query.isEmpty ? _selectedCategory : null,
            query: query.isEmpty ? null : query,
          ),
        );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
