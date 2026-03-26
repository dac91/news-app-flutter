import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/my_articles_cubit.dart';
import 'package:news_app_clean_architecture/shared/widgets/empty_state_widget.dart';

import '../../../../config/theme/design_tokens.dart';

/// Screen displaying articles authored by the current user.
///
/// Each article shows title, category, date, and an edit button that
/// navigates to [CreateArticlePage] in edit mode.
class MyArticlesScreen extends StatefulWidget {
  final String ownerUid;

  const MyArticlesScreen({Key? key, required this.ownerUid}) : super(key: key);

  @override
  State<MyArticlesScreen> createState() => _MyArticlesScreenState();
}

class _MyArticlesScreenState extends State<MyArticlesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyArticlesCubit>().fetchArticles(widget.ownerUid);
  }

  @override
  Widget build(BuildContext context) {
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
            final theme = Theme.of(context);
            final isIndexError =
                state.message.contains('requires an index');
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48,
                        color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(
                      isIndexError
                          ? 'Setting up database index. This may take a few minutes — please try again shortly.'
                          : state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MyArticlesCubit>().fetchArticles(widget.ownerUid);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
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
                  .fetchArticles(widget.ownerUid),
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
                borderRadius: AppRadius.smBorder,
                child: Image.network(
                  article.thumbnailUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.surfaceContainerHigh,
                    child: Icon(Icons.image,
                        color: theme.colorScheme.onSurfaceVariant),
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
                              borderRadius: AppRadius.xsBorder,
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
                            color: theme.colorScheme.onSurfaceVariant,
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
