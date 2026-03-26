import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../injection_container.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';
import '../../bloc/article/local/local_article_state.dart';
import '../../widgets/article_tile.dart';

class SavedArticles extends StatefulWidget {
  /// When true, shows a back button in the AppBar (push-based navigation).
  /// When false, shows no back button (tab-based navigation).
  final bool showBackButton;

  const SavedArticles({Key ? key, this.showBackButton = false}) : super(key: key);

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
                onTap: () => _onBackButtonTapped(context),
                child: Icon(Ionicons.chevron_back,
                    color: Theme.of(context).appBarTheme.iconTheme?.color),
              ),
            )
          : null,
      automaticallyImplyLeading: widget.showBackButton,
      title: const Text('Saved Articles'),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LocalArticleBloc, LocalArticlesState>(
      builder: (context, state) {
        if (state is LocalArticlesLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is LocalArticlesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  state.error.message ?? 'Failed to load saved articles',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => BlocProvider.of<LocalArticleBloc>(context)
                      .add(const GetSavedArticles()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is LocalArticlesDone) {
          return _buildArticlesList(state.articles!);
        }
        return Container();
      },
    );
  }

  Widget _buildArticlesList(List<ArticleEntity> articles) {
    if (articles.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.bookmark_border_rounded,
        title: 'No Saved Articles Yet',
        subtitle: 'Articles you bookmark will appear here.\nTap the bookmark icon on any article to save it.',
      );
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleWidget(
          article: articles[index],
          isRemovable: true,
          onRemove: (article) => _onRemoveArticle(context, article),
          onArticlePressed: (article) => _onArticlePressed(context, article),
        );
      },
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onRemoveArticle(BuildContext context, ArticleEntity article) {
    BlocProvider.of<LocalArticleBloc>(context).add(RemoveArticle(article));
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
