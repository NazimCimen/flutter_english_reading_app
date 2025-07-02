import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';

class WordBankDetailSheet extends StatelessWidget {
  final DictionaryEntry word;
  final VoidCallback? onWordDeleted;
  final VoidCallback? onWordEdited;

  const WordBankDetailSheet({
    super.key,
    required this.word,
    this.onWordDeleted,
    this.onWordEdited,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.cBorderRadiusAllLarge,
      ),
      padding: context.paddingAllLarge,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: context.cXLargeValue,
                height: context.cLowValue / 2,
                margin: context.paddingVertBottomLarge,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                  borderRadius: context.borderRadiusAllXLow,
                ),
              ),
            ),

            // Word header
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _editWord(context),
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Düzenle',
                ),
                IconButton(
                  onPressed: () => _deleteWord(context),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Sil',
                  color: AppColors.red,
                ),
              ],
            ),

            SizedBox(height: context.cLowValue),

            // Word details
            if (word.meanings.isNotEmpty) ...[
              ...word.meanings.map(
                (meaning) => _MeaningSection(meaning: meaning),
              ),
            ] else ...[
              Container(
                padding: context.paddingAllMedium,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                  borderRadius: context.borderRadiusAllMedium,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      size: context.cMediumValue,
                    ),
                    SizedBox(width: context.cLowValue),
                    Expanded(
                      child: Text(
                        'Bu kelime için detaylı anlam bilgisi bulunmuyor.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: context.cMediumValue),

            // Creation date
            if (word.createdAt != null) ...[
              Container(
                padding: context.paddingAllLow,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: context.borderRadiusAllLow,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: context.cMediumValue,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: context.cLowValue),
                    Text(
                      'Eklenme: ${_formatDate(word.createdAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: context.cLargeValue),
          ],
        ),
      ),
    );
  }

  void _editWord(BuildContext context) {
    Navigator.of(context).pop();
    NavigatorService.pushNamed(AppRoutes.addWordView, arguments: word);
    onWordEdited?.call();
  }

  void _deleteWord(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Kelimeyi Sil'),
            content: Text(
              '"${word.word}" kelimesini silmek istediğinizden emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  final provider = Provider.of<WordBankViewmodel>(
                    context,
                    listen: false,
                  );
                  if (word.documentId != null) {
                    ///provider.deleteWord(word.documentId!);
                  }
                  onWordDeleted?.call();
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.red),
                child: const Text('Sil'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _MeaningSection extends StatelessWidget {
  final Meaning meaning;

  const _MeaningSection({required this.meaning});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.label_important_outline,
              color: Theme.of(context).colorScheme.primary,
              size: context.cMediumValue,
            ),
            SizedBox(width: context.cLowValue / 2),
            Text(
              meaning.partOfSpeech,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: context.cLowValue / 2),
        ...meaning.definitions.map(
          (def) => _DefinitionSection(definition: def),
        ),
        SizedBox(height: context.cLowValue),
      ],
    );
  }
}

class _DefinitionSection extends StatelessWidget {
  final Definition definition;

  const _DefinitionSection({required this.definition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.paddingHorizLeftLow + context.paddingVertBottomLow,
      padding: context.paddingAllLow,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: context.borderRadiusAllLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.definition,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          if (definition.example != null && definition.example!.isNotEmpty) ...[
            SizedBox(height: context.cLowValue / 2),
            Row(
              children: [
                Icon(
                  Icons.format_quote,
                  size: context.cMediumValue,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: context.cLowValue / 4),
                Expanded(
                  child: Text(
                    '"${definition.example!}"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
