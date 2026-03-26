import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/theme/design_tokens.dart';

/// Skeleton shimmer placeholder for article list loading state.
///
/// Replaces the plain CupertinoActivityIndicator with a shimmer effect
/// that matches the article tile layout, giving users a preview of the
/// content structure while data loads.
class ArticleShimmerList extends StatelessWidget {
  final int itemCount;

  const ArticleShimmerList({Key? key, this.itemCount = 6}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const _ArticleShimmerTile(),
    );
  }
}

class _ArticleShimmerTile extends StatelessWidget {
  const _ArticleShimmerTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.surfaceContainerHigh : AppColors.lightSurfaceContainerHigh;
    final highlightColor = isDark ? AppColors.surfaceContainerHighest : AppColors.lightSurfaceContainerHighest;
    final shimmerFill = baseColor;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 2.2,
          child: Row(
            children: [
              // Image placeholder
              ClipRRect(
                borderRadius: AppRadius.mdBorder,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.maxFinite,
                  color: shimmerFill,
                ),
              ),
              const SizedBox(width: 14),
              // Text placeholders
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title line 1
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: shimmerFill,
                          borderRadius: AppRadius.xsBorder,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title line 2
                      Container(
                        height: 16,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          color: shimmerFill,
                          borderRadius: AppRadius.xsBorder,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description line
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: shimmerFill,
                          borderRadius: AppRadius.xsBorder,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          color: shimmerFill,
                          borderRadius: AppRadius.xsBorder,
                        ),
                      ),
                      const Spacer(),
                      // Date placeholder
                      Row(
                        children: [
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: shimmerFill,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            height: 12,
                            width: 80,
                            decoration: BoxDecoration(
                              color: shimmerFill,
                              borderRadius: AppRadius.xsBorder,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
