import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/decorations/input_decorations/custom_input_decoration.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';
import 'package:flutter/material.dart';

class MeaningCard extends StatefulWidget {
  final Meaning meaning;
  const MeaningCard({required this.meaning, super.key});

  @override
  State<MeaningCard> createState() => MeaningCardState();
}

class MeaningCardState extends State<MeaningCard> {
  TextEditingController partOfSpeechController = TextEditingController();
  List<TextEditingController> definitionControllers = [];
  @override
  void initState() {
    super.initState();
    initPartOfSpeechControllerList();
  }

  void disposeControllers() {
    partOfSpeechController.dispose();
    for (final controller in definitionControllers) {
      controller.dispose();
    }
    definitionControllers.clear();
  }

  void initPartOfSpeechControllerList() {
    partOfSpeechController = TextEditingController(
      text: widget.meaning.partOfSpeech,
    );

    for (final definition in widget.meaning.definitions) {
      definitionControllers.add(
        TextEditingController(text: definition.definition),
      );
    }
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

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

              SizedBox(width: context.cLowValue),
              IconButton(
                onPressed: () {
                  if (widget.meaning.id != null) {
                    context.read<AddWordViewModel>().removeMeaningById(
                      widget.meaning.id!,
                    );
                    initPartOfSpeechControllerList();
                  }
                },
                icon: Icon(Icons.delete_outline, color: AppColors.red),
                tooltip: 'Anlamı Sil',
              ),
            ],
          ),
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
                onPressed: () => (),
                icon: Icon(Icons.add, size: context.cLowValue),
                label: Text('Tanım Ekle'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.cLowValue),
          ...List.generate(
            definitionControllers.length,
            (definitionIndex) => Padding(
              padding: context.paddingAllLow / 1.5,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: definitionControllers[definitionIndex],
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
                      onPressed: () => (),
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: AppColors.red,
                      ),
                      tooltip: 'Tanımı Sil',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
