import 'package:flutter/material.dart';

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
    final isLight = theme.brightness == Brightness.light;

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
            onSelected: (_) {
              if (category == 'general') {
                onCategorySelected(null);
              } else {
                onCategorySelected(category);
              }
            },
            selectedColor: isLight ? Colors.black : Colors.white,
            backgroundColor:
                isLight ? Colors.grey.shade200 : Colors.grey.shade800,
            labelStyle: TextStyle(
              color: isSelected
                  ? (isLight ? Colors.white : Colors.black)
                  : (isLight ? Colors.black87 : Colors.white70),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          );
        },
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
