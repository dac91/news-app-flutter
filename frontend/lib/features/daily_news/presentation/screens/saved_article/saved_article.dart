import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../config/theme/design_tokens.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../injection_container.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';
import '../../bloc/article/local/local_article_state.dart';

class SavedArticles extends StatefulWidget {
  /// When true, shows a back button in the AppBar (push-based navigation).
  /// When false, shows no back button (tab-based navigation).
  final bool showBackButton;

  const SavedArticles({Key? key, this.showBackButton = false})
      : super(key: key);

  @override
  State<SavedArticles> createState() => SavedArticlesState();
}

/// Public state class so [MainNavigation] can call [refresh()] via a GlobalKey.
class SavedArticlesState extends State<SavedArticles> {
  late final LocalArticleBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<LocalArticleBloc>()..add(const GetSavedArticles());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  /// Called by [MainNavigation] when this tab is selected.
  /// Re-fetches saved articles to pick up bookmarks made from detail pages.
  void refresh() {
    _bloc.add(const GetSavedArticles());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: widget.showBackButton
          ? Builder(
              builder: (context) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(context),
                child: Icon(Ionicons.chevron_back,
                    color: Theme.of(context).appBarTheme.iconTheme?.color),
              ),
            )
          : null,
      automaticallyImplyLeading: widget.showBackButton,
      title: Text(
        'Saved Articles',
        style: GoogleFonts.newsreader(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LocalArticleBloc, LocalArticlesState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        if (state is LocalArticlesLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is LocalArticlesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 12),
                Text(
                  state.error.message ?? 'Failed to load saved articles',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => _bloc.add(const GetSavedArticles()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is LocalArticlesDone) {
          return _buildArticlesList(state.articles!);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildArticlesList(List<ArticleEntity> articles) {
    if (articles.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.bookmark_border_rounded,
        title: 'No Saved Articles Yet',
        subtitle:
            'Articles you bookmark will appear here.\nTap the bookmark icon on any article to save it.',
      );
    }

    return Column(
      children: [
        _buildReadingListHeader(articles.length),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return _buildDismissibleCard(context, articles[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReadingListHeader(int count) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Text(
                'Reading List',
                style: GoogleFonts.newsreader(
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '$count ${count == 1 ? 'ITEM' : 'ITEMS'}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDismissibleCard(
      BuildContext context, ArticleEntity article, int index) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: Key(article.url ?? article.title ?? index.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => _onRemoveArticle(context, article),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 28),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: AppRadius.mdBorder,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline,
                  color: theme.colorScheme.onError, size: 28),
              const SizedBox(height: 4),
              Text(
                'REMOVE',
                style: TextStyle(
                  color: theme.colorScheme.onError,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => _onArticlePressed(context, article),
          child: _buildSavedArticleCard(context, article),
        ),
      ),
    );
  }

  Widget _buildSavedArticleCard(BuildContext context, ArticleEntity article) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark
        ? AppColors.surfaceContainerHigh
        : AppColors.lightSurfaceContainerHigh;
    final placeholderColor = isDark
        ? AppColors.surfaceContainer
        : AppColors.lightSurfaceContainer;

    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: AppRadius.mdBorder,
      ),
      child: Row(
        children: [
          // Article image
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? kDefaultImage,
            imageBuilder: (context, imageProvider) => ClipRRect(
              borderRadius: AppRadius.smBorder,
              child: Container(
                width: 96,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, progress) => ClipRRect(
              borderRadius: AppRadius.smBorder,
              child: Container(
                width: 96,
                height: double.maxFinite,
                color: placeholderColor,
                child: const CupertinoActivityIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => ClipRRect(
              borderRadius: AppRadius.smBorder,
              child: Container(
                width: 96,
                height: double.maxFinite,
                color: placeholderColor,
                child: Icon(Icons.broken_image_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Title + Source + Bookmark
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.newsreader(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.3,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (article.author ?? 'Unknown Source').toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.bookmark,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onRemoveArticle(BuildContext context, ArticleEntity article) {
    BlocProvider.of<LocalArticleBloc>(context).add(RemoveArticle(article));
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
