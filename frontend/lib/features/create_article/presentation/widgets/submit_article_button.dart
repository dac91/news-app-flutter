import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A full-width submit button for the article creation form.
///
/// Shows a loading indicator when [isLoading] is true and disables
/// interaction. Provides clear visual states for enabled, disabled,
/// and loading.
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading ? _buildLoadingContent() : _buildLabelContent(),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(color: Colors.white),
        SizedBox(width: 12),
        Text(
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
