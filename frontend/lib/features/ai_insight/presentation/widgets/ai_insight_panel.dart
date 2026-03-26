import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: OutlinedButton.icon(
        onPressed: () {
          // The parent screen triggers getInsight on the cubit
          // when this button is pressed. We dispatch via context.
          _requestInsight(context);
        },
        icon: Icon(
          Icons.auto_awesome_outlined,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        label: Text(
          'Get AI Insight',
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _requestInsight(BuildContext context) {
    // Trigger is handled by the onTap callback provided by the parent.
    // The parent screen (article_detail.dart) provides a callback that
    // calls cubit.getInsight() with the actual article data.
    widget.onRequestInsight?.call();
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(height: 12),
              Text(
                'Analyzing article...',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, AiInsightError state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error_outline,
                  color: Theme.of(context).colorScheme.error, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Could not generate insight. Try again later.',
                  style: TextStyle(fontSize: 13),
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
          borderRadius: BorderRadius.circular(12),
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
                      color: Colors.grey,
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
                  const Text(
                    'Key Points',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...insight.summaryBullets.map(
                    (bullet) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('  \u2022  ',
                              style: TextStyle(fontSize: 13)),
                          Expanded(
                            child: Text(
                              bullet,
                              style: const TextStyle(fontSize: 13, height: 1.4),
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
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
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
        borderRadius: BorderRadius.circular(8),
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
        return Colors.blue;
      case 'critical':
        return Colors.orange;
      case 'supportive':
        return Colors.green;
      case 'alarming':
        return Colors.red;
      case 'optimistic':
        return Colors.teal;
      case 'analytical':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              content,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
