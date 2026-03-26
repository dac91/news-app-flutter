import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/design_tokens.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_cubit.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_state.dart';

/// A collapsible panel that displays AI-generated article insights.
///
/// Shows a summary, tone analysis, source context, and emphasis analysis.
/// Includes an "AI-generated" disclaimer and "Read original" link.
///
/// Research backing:
/// - 58% worry about fake news (Reuters DNR 2025)
/// - Readers want "where the information is from and the political view"
/// - Framed as perspective context, NOT fact-checking (Assumption 14)
class AiInsightPanel extends StatefulWidget {
  final String? articleUrl;
  final VoidCallback? onRequestInsight;

  const AiInsightPanel({Key? key, this.articleUrl, this.onRequestInsight})
      : super(key: key);

  @override
  State<AiInsightPanel> createState() => _AiInsightPanelState();
}

class _AiInsightPanelState extends State<AiInsightPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiInsightCubit, AiInsightState>(
      builder: (context, state) {
        if (state is AiInsightInitial) {
          return _buildTriggerButton(context);
        }

        if (state is AiInsightLoading) {
          return _buildLoadingCard(context);
        }

        if (state is AiInsightError) {
          return _buildErrorCard(context, state);
        }

        if (state is AiInsightLoaded) {
          return _buildInsightCard(context, state.insight);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTriggerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: OutlinedButton.icon(
        onPressed: () {
          _requestInsight(context);
        },
        icon: const Icon(Icons.auto_awesome_outlined, size: 18),
        label: const Text('Get AI Insight'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _requestInsight(BuildContext context) {
    widget.onRequestInsight?.call();
  }

  Widget _buildLoadingCard(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdBorder,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(height: 12),
              Text(
                'Analyzing article...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, AiInsightError state) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.errorContainer.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdBorder,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error_outline,
                  color: theme.colorScheme.error, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Could not generate insight. Try again later.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, AiInsightEntity insight) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdBorder,
          side: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (always visible)
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Insight',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    _buildToneBadge(context, insight.tone),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),

            // Summary bullets (always visible when loaded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Points',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...insight.summaryBullets.map(
                    (bullet) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  \u2022  ',
                              style: theme.textTheme.bodySmall),
                          Expanded(
                            child: Text(
                              bullet,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Expanded details
            if (_isExpanded) ...[
              const Divider(height: 24, indent: 16, endIndent: 16),

              // Tone Analysis
              _buildSection(
                context,
                icon: Icons.mood,
                title: 'Tone',
                content: insight.toneExplanation,
              ),

              // Source Context
              _buildSection(
                context,
                icon: Icons.source_outlined,
                title: 'Source Context',
                content: insight.sourceContext,
              ),

              // Emphasis Analysis
              _buildSection(
                context,
                icon: Icons.balance,
                title: 'What\'s Emphasized',
                content: insight.emphasisAnalysis,
              ),
            ],

            // Disclaimer (always visible)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'AI-generated summary \u2014 verify independently',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToneBadge(BuildContext context, String tone) {
    final color = _toneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.smBorder,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        tone.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
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

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16,
                  color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              content,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
