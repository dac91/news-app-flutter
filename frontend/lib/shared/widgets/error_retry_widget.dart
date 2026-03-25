import 'package:flutter/material.dart';

/// Reusable error-with-retry widget used across multiple features.
///
/// Displays an icon, error message, and a "Tap to retry" affordance.
/// Used by daily_news home, saved articles, and any future list screen
/// that needs a recoverable error state.
class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const ErrorRetryWidget({
    Key? key,
    this.message = 'Something went wrong',
    required this.onRetry,
    this.icon = Icons.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: GestureDetector(
        onTap: onRetry,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to retry',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
