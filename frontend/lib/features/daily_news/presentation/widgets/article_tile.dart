import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/design_tokens.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  final bool? isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;

  const ArticleWidget({
    Key? key,
    this.article,
    this.onArticlePressed,
    this.isRemovable = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
            start: 14, end: 14, bottom: 7, top: 7),
        height: MediaQuery.of(context).size.width / 2.2,
        child: Row(
          children: [
            _buildImage(context),
            _buildTitleAndDescription(context),
            _buildRemovableArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);
    const placeholderColor = AppColors.surfaceContainerHigh;
    final heroTag = 'article-image-${article?.id ?? article?.title?.hashCode ?? 0}';
    return Hero(
      tag: heroTag,
      child: CachedNetworkImage(
        imageUrl: article?.urlToImage ?? kDefaultImage,
        imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: AppRadius.mdBorder,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      color: placeholderColor,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                ),
              ),
            ),
        progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: AppRadius.mdBorder,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: placeholderColor,
                  ),
                  child: const CupertinoActivityIndicator(),
                ),
              ),
            ),
        errorWidget: (context, url, error) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: AppRadius.mdBorder,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: placeholderColor,
                  ),
                  child: Icon(Icons.error,
                      color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            )),
    );
  }

  Widget _buildTitleAndDescription(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              article?.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.newsreader(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),

            // Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  article?.description ?? '',
                  maxLines: 2,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            // Datetime
            Row(
              children: [
                Icon(Icons.timeline_outlined, size: 16,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  article?.publishedAt ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableArea(BuildContext context) {
    if (isRemovable ?? false) {
      return GestureDetector(
        onTap: _onRemove,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.remove_circle_outline,
              color: Theme.of(context).colorScheme.error),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _onTap() {
    final currentArticle = article;
    if (currentArticle != null && onArticlePressed != null) {
      onArticlePressed!(currentArticle);
    }
  }

  void _onRemove() {
    final currentArticle = article;
    if (currentArticle != null && onRemove != null) {
      onRemove!(currentArticle);
    }
  }
}
