import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../injection_container.dart';
import '../../../../../features/ai_insight/presentation/cubit/ai_insight_cubit.dart';
import '../../../../../features/ai_insight/presentation/widgets/ai_insight_panel.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';
import '../../bloc/article/local/local_article_state.dart';

class ArticleDetailsView extends StatefulWidget {
  final ArticleEntity? article;

  const ArticleDetailsView({Key? key, this.article}) : super(key: key);

  @override
  State<ArticleDetailsView> createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<ArticleDetailsView> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
        ),
        BlocProvider(
          create: (_) => sl<AiInsightCubit>(),
        ),
      ],
      child: BlocListener<LocalArticleBloc, LocalArticlesState>(
        listener: _onLocalArticlesState,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
          floatingActionButton: _buildFloatingActionButton(),
        ),
      ),
    );
  }

  /// Updates [_isBookmarked] whenever the saved articles list changes.
  void _onLocalArticlesState(BuildContext context, LocalArticlesState state) {
    if (state is LocalArticlesDone) {
      final saved = state.articles ?? [];
      final isSaved = saved.any((a) => a.url == widget.article?.url);
      if (_isBookmarked != isSaved) {
        setState(() => _isBookmarked = isSaved);
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonTapped(context),
          child: Icon(Ionicons.chevron_back,
              color: Theme.of(context).appBarTheme.iconTheme?.color),
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share article',
            onPressed: () => _onSharePressed(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildArticleTitleAndDate(),
          _buildArticleImage(),
          _buildArticleDescription(),
          _buildAiInsightSection(),
        ],
      ),
    );
  }

  Widget _buildArticleTitleAndDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.article?.title ?? '',
            style: const TextStyle(
                fontFamily: 'Butler',
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 14),
          // DateTime
          Row(
            children: [
              const Icon(Ionicons.time_outline, size: 16),
              const SizedBox(width: 4),
              Text(
                widget.article?.publishedAt ?? '',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleImage() {
    final heroTag =
        'article-image-${widget.article?.id ?? widget.article?.title?.hashCode ?? 0}';
    return Hero(
      tag: heroTag,
      child: Container(
        width: double.maxFinite,
        height: 250,
        margin: const EdgeInsets.only(top: 14),
        child: Image.network(
          widget.article?.urlToImage ?? kDefaultImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade200,
            child: Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Text(
        '${widget.article?.description ?? ''}\n\n${widget.article?.content ?? ''}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildAiInsightSection() {
    return AiInsightPanel(
      articleUrl: widget.article?.url,
      onRequestInsight: () {
        context.read<AiInsightCubit>().getInsight(
              title: widget.article?.title ?? '',
              description: widget.article?.description,
              content: widget.article?.content,
              source: widget.article?.author,
              url: widget.article?.url,
            );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Builder(
      builder: (context) => FloatingActionButton(
        onPressed: () => _onFloatingActionButtonPressed(context),
        child: Icon(
          _isBookmarked ? Ionicons.bookmark : Ionicons.bookmark_outline,
          color: Theme.of(context)
              .floatingActionButtonTheme
              .foregroundColor,
        ),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFloatingActionButtonPressed(BuildContext context) {
    final currentArticle = widget.article;
    if (currentArticle == null) return;

    final bloc = BlocProvider.of<LocalArticleBloc>(context);

    if (_isBookmarked) {
      bloc.add(RemoveArticle(currentArticle));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bookmark removed'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else {
      bloc.add(SaveArticle(currentArticle));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Article bookmarked'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _onSharePressed(BuildContext context) {
    final title = widget.article?.title ?? 'Check out this article';
    final url = widget.article?.url ?? '';
    final shareText = url.isNotEmpty ? '$title\n\n$url' : title;
    Share.share(shareText, subject: title);
  }
}
