import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/feature/article_detail/presentation/viewmodel/article_detail_view_model.dart';
import 'package:english_reading_app/feature/article_detail/presentation/widget/font_size_slider.dart';
import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';

@immutable
final class CustomSheets {
  const CustomSheets._();
  static void showDefinitionSheet({
    required BuildContext context,
    required String selected,
    required List<Definition> combinedResults,
    VoidCallback? onSave,
  }) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: context.cPaddingMedium,
          child: Wrap(
            children: [
              ...combinedResults.map(
                (entry) => ListTile(
                  title: Text(
                    entry.text!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (entry.phraseType != null)
                        Text(
                          '(${entry.phraseType})',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      for (final meaning in entry.meanings!)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(meaning),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"$selected" kelime bankasına eklendi'),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showFontSizeSheet(
    BuildContext context,
    ArticleDetailViewModel viewModel,
  ) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: ContinuousRectangleBorder(
        borderRadius: context.borderRadiusAllLarge,
      ),
      builder: (context) {
        return FontSizeSlider(viewModel);
      },
    );
  }

  static void showSheetFlexibleWithKeyboard(
    BuildContext context,
    Widget Function({double bottomPadding, double bottomInsets}) child,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        return child(bottomInsets: bottomInsets, bottomPadding: bottomPadding);
      },
    );
  }
}
