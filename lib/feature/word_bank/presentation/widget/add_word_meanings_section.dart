import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/decorations/input_decorations/custom_input_decoration.dart';
import 'package:english_reading_app/feature/word_bank/presentation/view/add_word_view.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';

class AddWordMeaningsSection extends StatelessWidget {
  final List<MeaningData> meanings;
  final List<TextEditingController> partOfSpeechControllers;
  final List<TextEditingController> definitionControllers;
  final VoidCallback onAddMeaning;
  final Function(int) onRemoveMeaning;
  final Function(int) onAddDefinition;
  final Function(int, int) onRemoveDefinition;
  final int Function(int, int) getDefinitionControllerIndex;

  const AddWordMeaningsSection({
    super.key,
    required this.meanings,
    required this.partOfSpeechControllers,
    required this.definitionControllers,
    required this.onAddMeaning,
    required this.onRemoveMeaning,
    required this.onAddDefinition,
    required this.onRemoveDefinition,
    required this.getDefinitionControllerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Anlamlar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: onAddMeaning,
              icon: Icon(Icons.add, size: context.cMediumValue),
              label: Text('Anlam Ekle'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: context.cMediumValue),
        ...List.generate(meanings.length, (meaningIndex) => 
          _MeaningCard(
            meaningIndex: meaningIndex,
            meaning: meanings[meaningIndex],
            partOfSpeechController: partOfSpeechControllers[meaningIndex],
            definitionControllers: definitionControllers,
            onRemoveMeaning: onRemoveMeaning,
            onAddDefinition: onAddDefinition,
            onRemoveDefinition: onRemoveDefinition,
            getDefinitionControllerIndex: getDefinitionControllerIndex,
          ),
        ),
      ],
    );
  }
}

class _MeaningCard extends StatelessWidget {
  final int meaningIndex;
  final MeaningData meaning;
  final TextEditingController partOfSpeechController;
  final List<TextEditingController> definitionControllers;
  final Function(int) onRemoveMeaning;
  final Function(int) onAddDefinition;
  final Function(int, int) onRemoveDefinition;
  final int Function(int, int) getDefinitionControllerIndex;

  const _MeaningCard({
    required this.meaningIndex,
    required this.meaning,
    required this.partOfSpeechController,
    required this.definitionControllers,
    required this.onRemoveMeaning,
    required this.onAddDefinition,
    required this.onRemoveDefinition,
    required this.getDefinitionControllerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.paddingVertBottomMedium,
      padding: context.paddingAllMedium,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.borderRadiusAllMedium,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: context.cLowValue / 4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: partOfSpeechController,
                  decoration: CustomInputDecoration.inputDecoration(
                    context: context,
                    hintText: 'Örnek: noun, verb, adjective',
                  ).copyWith(
                    labelText: 'Kelime Türü',
                    prefixIcon: Icon(Icons.category),
                  ),
                  validator: AppValidators.partOfSpeechValidator,
                ),
              ),
              if (meaning.definitions.length > 1) ...[
                SizedBox(width: context.cLowValue),
                IconButton(
                  onPressed: () => onRemoveMeaning(meaningIndex),
                  icon: Icon(Icons.delete_outline, color: AppColors.red),
                  tooltip: 'Anlamı Sil',
                ),
              ],
            ],
          ),
          SizedBox(height: context.cMediumValue),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tanımlar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () => onAddDefinition(meaningIndex),
                icon: Icon(Icons.add, size: context.cLowValue),
                label: Text('Tanım Ekle'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.cLowValue),
          ...List.generate(meaning.definitions.length, (definitionIndex) =>
            _DefinitionField(
              meaningIndex: meaningIndex,
              definitionIndex: definitionIndex,
              definitionControllers: definitionControllers,
              onRemoveDefinition: onRemoveDefinition,
              getDefinitionControllerIndex: getDefinitionControllerIndex,
            ),
          ),
        ],
      ),
    );
  }
}

class _DefinitionField extends StatelessWidget {
  final int meaningIndex;
  final int definitionIndex;
  final List<TextEditingController> definitionControllers;
  final Function(int, int) onRemoveDefinition;
  final int Function(int, int) getDefinitionControllerIndex;

  const _DefinitionField({
    required this.meaningIndex,
    required this.definitionIndex,
    required this.definitionControllers,
    required this.onRemoveDefinition,
    required this.getDefinitionControllerIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controllerIndex = getDefinitionControllerIndex(meaningIndex, definitionIndex);
    
    return Container(
      margin: context.paddingVertBottomLow,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: definitionControllers[controllerIndex],
              decoration: CustomInputDecoration.inputDecoration(
                context: context,
                hintText: 'Kelimenin anlamını girin',
              ).copyWith(
                labelText: 'Tanım ${definitionIndex + 1}',
                prefixIcon: Icon(Icons.translate),
              ),
              maxLines: 2,
              validator: AppValidators.definitionValidator,
            ),
          ),
          if (definitionControllers.length > 1) ...[
            SizedBox(width: context.cLowValue),
            IconButton(
              onPressed: () => onRemoveDefinition(meaningIndex, definitionIndex),
              icon: Icon(Icons.remove_circle_outline, color: AppColors.red),
              tooltip: 'Tanımı Sil',
            ),
          ],
        ],
      ),
    );
  }
} 