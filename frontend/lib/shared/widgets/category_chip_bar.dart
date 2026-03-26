import 'package:flutter/material.dart';

import '../../config/theme/design_tokens.dart';

/// Horizontal scrollable bar of category filter chips.
///
/// Tapping a chip selects it (or deselects if already active).
/// The first chip is always "All" which clears the filter.
class CategoryChipBar extends StatelessWidget {
  /// Available NewsAPI top-headline categories.
  static const List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryChipBar({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category ||
              (selectedCategory == null && category == 'general');

          return ChoiceChip(
            label: Text(_capitalize(category)),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) {
              if (category == 'general') {
                onCategorySelected(null);
              } else {
                onCategorySelected(category);
              }
            },
            selectedColor: theme.colorScheme.primary,
            backgroundColor: isDark
                ? AppColors.surfaceContainerHighest
                : AppColors.lightSurfaceContainerHighest,
            labelStyle: TextStyle(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          );
        },
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
