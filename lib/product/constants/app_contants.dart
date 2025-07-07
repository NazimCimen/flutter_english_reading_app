import 'package:english_reading_app/product/model/article_model.dart';
import 'package:english_reading_app/product/model/category_model.dart';
import 'package:flutter/material.dart';

@immutable
final class AppContants {
  const AppContants._();
  static const String appName = 'Lingzy';

  static final List<CategoryModel> categories = [
    const CategoryModel(
      emoji: '🌐',
      name: 'all',
      displayName: 'All Topics',
      color: Color(0xFF9333EA),
    ),
    const CategoryModel(
      emoji: '📚',
      name: 'short_stories',
      displayName: 'Story Time',
      color: Color(0xFF6D28D9),
    ),
    const CategoryModel(
      emoji: '⚽',
      name: 'sports',
      displayName: 'Sports World',
      color: Color(0xFF059669),
    ),
    const CategoryModel(
      emoji: '💼',
      name: 'economy',
      displayName: 'Business Insights',
      color: Color(0xFFF59E0B),
    ),
    const CategoryModel(
      emoji: '📱',
      name: 'technology',
      displayName: 'Tech Today',
      color: Color(0xFF3B82F6),
    ),
    const CategoryModel(
      emoji: '🔬',
      name: 'science',
      displayName: 'Science Frontier',
      color: Color(0xFFEC4899),
    ),
    const CategoryModel(
      emoji: '✈️',
      name: 'travel',
      displayName: 'Global Explorer',
      color: Color(0xFF14B8A6),
    ),
    const CategoryModel(
      emoji: '🏥',
      name: 'health',
      displayName: 'Healthy Living',
      color: Color(0xFFEF4444),
    ),
    const CategoryModel(
      emoji: '🍕',
      name: 'food',
      displayName: 'Food Culture',
      color: Color(0xFFF97316),
    ),
    const CategoryModel(
      emoji: '💪',
      name: 'motivation',
      displayName: 'Peak Performance',
      color: Color(0xFF8B5CF6),
    ),
  ];

  static String getDisplayNameWithEmoji(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) return '';
    final category = AppContants.categories.firstWhere(
      (cat) => cat.name == categoryName,
      orElse:
          () => const CategoryModel(
            name: '',
            displayName: '',
            emoji: '',
            color: Colors.transparent,
          ),
    );
    return '${category.emoji} ${category.displayName.isNotEmpty ? category.displayName : categoryName}';
  }

  static List<Definition> handleSelection({
    required String selected,
    required List<Definition>? definitions,
  }) {
    final lowerSelected = selected.toLowerCase();
    if (definitions == null) return [];

    /// 1. Direct match
    final exactMatches =
        definitions
            .where((word) => word.text?.toLowerCase() == lowerSelected)
            .toList();

    /// 2. Find phrases containing this word (e.g., 'give' -> 'give up')
    final partialMatches =
        definitions
            .where(
              (word) =>
                  word.text!.toLowerCase().contains(lowerSelected) &&
                  word.text!.toLowerCase() != lowerSelected,
            )
            .toList();

    final combinedResults = [...exactMatches, ...partialMatches];
    return combinedResults;
  }
}
