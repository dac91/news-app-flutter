import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_clean_architecture/config/theme/design_tokens.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_cubit.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modal bottom sheet that displays AI-generated article insights.
///
/// One-click action: tapping "Generate AI Insight" on article detail
/// immediately triggers generation AND opens this bottom sheet.
///
/// Research backing:
/// - 58% worry about fake news (Reuters DNR 2025)
/// - Readers want "where the information is from and the political view"
/// - Framed as perspective context, NOT fact-checking (Assumption 14)
class AiInsightPanel extends StatelessWidget {
  /// The original article URL, used for the "Read original" link.
  final String? articleUrl;

  const AiInsightPanel({Key? key, this.articleUrl}) : super(key: key);

  /// Shows the AI insight bottom sheet and triggers generation if needed.
  ///
  /// If the cubit is already in [AiInsightLoaded] state, shows existing data
  /// without re-fetching. Otherwise triggers generation and shows the sheet.
  static void show({
    required BuildContext context,
    required AiInsightCubit cubit,
    String title = '',
    String? description,
    String? content,
    String? source,
    String? url,
  }) {
    // Only fetch if not already loaded
    if (cubit.state is! AiInsightLoaded) {
      cubit.getInsight(
        title: title,
        description: description,
        content: content,
        source: source,
        url: url,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AiInsightPanel(articleUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AiInsightCubit, AiInsightState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceContainerHigh
                    : AppColors.lightSurfaceContainerHigh,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDragHandle(theme),
                    _buildHeader(context, theme),
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant,
                    ),
                    if (state is AiInsightLoading || state is AiInsightInitial)
                      _buildLoading(theme),
                    if (state is AiInsightLoaded)
                      _buildContent(theme, state.insight, isDark),
                    if (state is AiInsightError)
                      _buildError(theme),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: theme.colorScheme.outlineVariant,
          borderRadius: AppRadius.fullBorder,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            size: 22,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Insight',
                  style: GoogleFonts.newsreader(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'GENERATED BY SYMMETRY INTELLIGENCE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Analyzing article...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 40, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Could not generate insight',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Please try again later.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AiInsightEntity insight, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Summary chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.15),
              borderRadius: AppRadius.smBorder,
            ),
            child: Text(
              'EXECUTIVE SUMMARY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Summary quote (italic Newsreader)
          Text(
            '\u201C${insight.emphasisAnalysis}\u201D',
            style: GoogleFonts.newsreader(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),

          // Bullet points with colored dots
          ...insight.summaryBullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bullet,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tone + Political Leaning badges (side by side)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildToneBadge(theme, insight.tone, isDark),
              _buildPoliticalLeaningBadge(theme, insight.politicalLeaning),
            ],
          ),

          // Source context
          if (insight.sourceContext.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Source Context',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              insight.sourceContext,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // "Read original" link + Disclaimer row
          Row(
            children: [
              Expanded(
                child: Text(
                  'AI-generated summary \u2014 verify independently',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              if (articleUrl != null && articleUrl!.isNotEmpty)
                GestureDetector(
                  onTap: () => _launchUrl(articleUrl!),
                  child: Text(
                    'Read original',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToneBadge(ThemeData theme, String tone, bool isDark) {
    final color = _toneColor(tone);
    // Use higher opacity on light theme for better contrast
    final bgOpacity = isDark ? 0.1 : 0.15;
    final borderOpacity = isDark ? 0.3 : 0.5;
    // On light theme, darken the text color for better readability
    final textColor = isDark ? color : _darkenColor(color, 0.3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(bgOpacity),
        borderRadius: AppRadius.smBorder,
        border: Border.all(color: color.withOpacity(borderOpacity)),
      ),
      child: Text(
        tone.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Displays the political leaning as a badge with a spectrum icon.
  ///
  /// Research backing: "Say where the information is from and the political
  /// view of the author" — Female, 21, UK (Reuters DNR 2025).
  Widget _buildPoliticalLeaningBadge(ThemeData theme, String leaning) {
    final label = _formatLeaning(leaning);
    final color = _leaningColor(leaning);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: AppRadius.smBorder,
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.balance, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Darkens a color by mixing it with black.
  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }

  Color _toneColor(String tone) {
    switch (tone.toLowerCase()) {
      case 'neutral':
        return AppColors.toneNeutral;
      case 'critical':
        return AppColors.toneCritical;
      case 'supportive':
        return AppColors.toneSupportive;
      case 'alarming':
        return AppColors.toneAlarming;
      case 'optimistic':
        return AppColors.toneOptimistic;
      case 'analytical':
        return AppColors.toneAnalytical;
      default:
        return AppColors.toneNeutral;
    }
  }

  /// Maps political leaning to a display-friendly label.
  String _formatLeaning(String leaning) {
    switch (leaning.toLowerCase()) {
      case 'left':
        return 'LEFT';
      case 'center-left':
        return 'CENTER-LEFT';
      case 'center':
        return 'CENTER';
      case 'center-right':
        return 'CENTER-RIGHT';
      case 'right':
        return 'RIGHT';
      default:
        return 'UNKNOWN';
    }
  }

  /// Maps political leaning to a color on a spectrum.
  ///
  /// Uses the existing design token palette — avoids introducing
  /// literal "red = right / blue = left" US-centric colors, instead
  /// using the app's semantic teal/warm palette.
  Color _leaningColor(String leaning) {
    switch (leaning.toLowerCase()) {
      case 'left':
        return AppColors.toneOptimistic; // teal-blue
      case 'center-left':
        return AppColors.toneAnalytical; // muted teal
      case 'center':
        return AppColors.toneNeutral; // grey
      case 'center-right':
        return AppColors.tertiary; // warm peach
      case 'right':
        return AppColors.toneCritical; // warm orange
      default:
        return AppColors.toneNeutral; // grey for unknown
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
