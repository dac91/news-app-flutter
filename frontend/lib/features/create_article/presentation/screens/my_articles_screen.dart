import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/my_articles_cubit.dart';
import 'package:news_app_clean_architecture/shared/widgets/empty_state_widget.dart';

/// Screen displaying articles authored by the current user.
///
/// Each article shows title, category, date, and an edit button that
/// navigates to [CreateArticlePage] in edit mode.
class MyArticlesScreen extends StatelessWidget {
  final String authorName;

  const MyArticlesScreen({Key? key, required this.authorName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger fetch on build
    context.read<MyArticlesCubit>().fetchArticles(authorName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Articles'),
        centerTitle: true,
      ),
      body: BlocBuilder<MyArticlesCubit, MyArticlesState>(
        builder: (context, state) {
          if (state is MyArticlesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MyArticlesError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MyArticlesCubit>().fetchArticles(authorName);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MyArticlesLoaded) {
            if (state.articles.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.article_outlined,
                title: 'No articles yet',
                subtitle: 'Articles you create will appear here',
              );
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<MyArticlesCubit>()
                  .fetchArticles(authorName),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _MyArticleTile(article: state.articles[index]);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Tile showing a user-created article with title, category, date, and edit action.
class _MyArticleTile extends StatelessWidget {
  final FirebaseArticleEntity article;

  const _MyArticleTile({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = article.createdAt;
    final dateStr = date != null
        ? '${date.day}/${date.month}/${date.year}'
        : 'Unknown date';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToEdit(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.thumbnailUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title + meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (article.category != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              article.category!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          dateStr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit button
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit article',
                onPressed: () => _navigateToEdit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.pushNamed(context, '/EditArticle', arguments: article);
  }
}
