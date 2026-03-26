import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A full-width submit button for the article creation form.
///
/// Shows a loading indicator when [isLoading] is true and disables
/// interaction. Inherits colors and shape from the app's
/// [ElevatedButtonThemeData].
class SubmitArticleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const SubmitArticleButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.label = 'Publish Article',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? _buildLoadingContent(context) : _buildLabelContent(),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(width: 12),
        const Text(
          'Publishing...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildLabelContent() {
    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
