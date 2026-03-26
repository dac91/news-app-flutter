import 'package:flutter/material.dart';

/// A reusable text form field for article creation forms.
///
/// Wraps [TextFormField] with consistent styling, validation, and character
/// counting. Supports single-line and multi-line inputs.
/// Inherits border/fill/radius from the app's [InputDecorationTheme].
class ArticleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLength;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final bool readOnly;

  const ArticleTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        textInputAction: textInputAction,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: readOnly
              ? const Tooltip(
                  message: 'Set from your account profile',
                  child: Icon(Icons.lock_outline, size: 18),
                )
              : null,
        ),
        validator: validator ?? _defaultValidator,
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }
}
