import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../config/theme/design_tokens.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../injection_container.dart';
import '../../../../../features/ai_insight/presentation/cubit/ai_insight_cubit.dart';
import '../../../../../features/ai_insight/presentation/cubit/ai_insight_state.dart';
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
          body: _buildBody(),
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

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage(),
          _buildMetaRow(),
          _buildTitle(),
          _buildAuthorRow(),
          _buildAiInsightButton(),
          _buildArticleContent(),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    final heroTag =
        'article-image-${widget.article?.id ?? widget.article?.title?.hashCode ?? 0}';
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Stack(
          children: [
            // Hero image
            Hero(
              tag: heroTag,
              child: Container(
                width: double.infinity,
                height: 300,
                color: isDark
                    ? AppColors.surfaceContainerHigh
                    : AppColors.lightSurfaceContainerHigh,
                child: Image.network(
                  widget.article?.urlToImage ?? kDefaultImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            // Back button
            Positioned(
              top: mediaQuery.padding.top + 8,
              left: 12,
              child: _buildOverlayButton(
                context: context,
                icon: Ionicons.chevron_back,
                onTap: () => Navigator.pop(context),
              ),
            ),
            // Share + Bookmark
            Positioned(
              top: mediaQuery.padding.top + 8,
              right: 12,
              child: Row(
                children: [
                  _buildOverlayButton(
                    context: context,
                    icon: Icons.share_outlined,
                    onTap: () => _onSharePressed(context),
                  ),
                  const SizedBox(width: 8),
                  _buildOverlayButton(
                    context: context,
                    icon: _isBookmarked
                        ? Ionicons.bookmark
                        : Ionicons.bookmark_outline,
                    onTap: () => _onBookmarkPressed(context),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverlayButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface.withOpacity(0.5),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildMetaRow() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final readTime = _estimateReadTime();
        final source = widget.article?.author ?? 'Unknown Source';

        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
          child: Text(
            '${source.toUpperCase()} \u2022 $readTime MIN READ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
          child: Text(
            widget.article?.title ?? '',
            style: GoogleFonts.newsreader(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthorRow() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final author = widget.article?.author ?? 'Unknown';
        final date = widget.article?.publishedAt ?? '';
        final initial = author.isNotEmpty ? author[0].toUpperCase() : '?';

        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  initial,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (date.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAiInsightButton() {
    return Builder(
      builder: (innerContext) {
        return BlocBuilder<AiInsightCubit, AiInsightState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;
            final isLoading = state is AiInsightLoading;
            final isLoaded = state is AiInsightLoaded;

            final label =
                isLoaded ? 'View AI Insight' : 'Generate AI Insight';

            return Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
              child: GestureDetector(
                onTap: isLoading
                    ? null
                    : () => _onAiInsightTapped(innerContext),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceContainerHigh
                        : AppColors.lightSurfaceContainerHigh,
                    borderRadius: AppRadius.mdBorder,
                  ),
                  child: Row(
                    children: [
                      if (isLoading)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      else
                        Icon(
                          Icons.auto_awesome,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildArticleContent() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
          child: Text(
            '${widget.article?.description ?? ''}\n\n${widget.article?.content ?? ''}',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        );
      },
    );
  }

  void _onAiInsightTapped(BuildContext context) {
    AiInsightPanel.show(
      context: context,
      cubit: context.read<AiInsightCubit>(),
      title: widget.article?.title ?? '',
      description: widget.article?.description,
      content: widget.article?.content,
      source: widget.article?.author,
      url: widget.article?.url,
    );
  }

  void _onBookmarkPressed(BuildContext context) {
    final currentArticle = widget.article;
    if (currentArticle == null) return;

    final bloc = BlocProvider.of<LocalArticleBloc>(context);

    if (_isBookmarked) {
      bloc.add(RemoveArticle(currentArticle));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed')),
      );
    } else {
      bloc.add(SaveArticle(currentArticle));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article bookmarked')),
      );
    }
  }

  void _onSharePressed(BuildContext context) {
    final title = widget.article?.title ?? 'Check out this article';
    final url = widget.article?.url ?? '';
    final shareText = url.isNotEmpty ? '$title\n\n$url' : title;
    Share.share(shareText, subject: title);
  }

  int _estimateReadTime() {
    final text =
        '${widget.article?.description ?? ''} ${widget.article?.content ?? ''}';
    final wordCount =
        text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
