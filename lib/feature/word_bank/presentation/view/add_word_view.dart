import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/decorations/input_decorations/custom_input_decoration.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/add_word_meanings_section.dart';
import 'package:english_reading_app/feature/word_bank/presentation/mixin/add_word_mixin.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';

class AddWordView extends StatefulWidget {
  final DictionaryEntry? existingWord;
  const AddWordView({super.key, this.existingWord});

  @override
  State<AddWordView> createState() => _AddWordViewState();
}

class _AddWordViewState extends State<AddWordView> with AddWordMixin {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewmodel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          widget.existingWord == null ? 'Kelime Ekle' : 'Kelime Düzenle',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (isLoading)
            Padding(
              padding: context.paddingAllMedium,
              child: SizedBox(
                width: context.cMediumValue,
                height: context.cMediumValue,
                child: CircularProgressIndicator(
                  strokeWidth: context.cLowValue / 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => onSavePressed(context, provider),
            ),
        ],
      ),
      body: Padding(
        padding: context.paddingAllMedium,
        child: Form(
          key: formKeyInstance,
          child: ListView(
            children: [
              // Kelime alanı
              TextFormField(
                controller: wordControllerInstance,
                decoration: CustomInputDecoration.inputDecoration(
                  context: context,
                  hintText: 'Örnek: apple, beautiful, happiness',
                ).copyWith(
                  labelText: 'Kelime',
                  prefixIcon: const Icon(Icons.text_fields),
                ),
                textCapitalization: TextCapitalization.none,
                validator: AppValidators.wordValidator,
              ),
              SizedBox(height: context.cMediumValue),

              // Anlamlar bölümü
              AddWordMeaningsSection(
                meanings: meanings,
                partOfSpeechControllers: partOfSpeechControllers,
                definitionControllers: definitionControllers,
                onAddMeaning: addMeaning,
                onRemoveMeaning: removeMeaning,
                onAddDefinition: addDefinition,
                onRemoveDefinition: removeDefinition,
                getDefinitionControllerIndex: getDefinitionControllerIndex,
              ),

              SizedBox(height: context.cXLargeValue),

              // Kaydet butonu
              ElevatedButton(
                onPressed:
                    isLoading ? null : () => onSavePressed(context, provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  minimumSize: Size.fromHeight(context.cXxLargeValue),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.borderRadiusAllMedium,
                  ),
                  elevation: context.cLowValue / 4,
                ),
                child:
                    isLoading
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: context.cMediumValue,
                              height: context.cMediumValue,
                              child: CircularProgressIndicator(
                                strokeWidth: context.cLowValue / 4,
                                valueColor:const AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: context.cLowValue),
                            Text(
                              'Kaydediliyor...',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                        : Text(
                          widget.existingWord == null
                              ? 'Kelime Ekle'
                              : 'Güncelle',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),

              SizedBox(height: context.cMediumValue),

              // Bilgi kartı
              Container(
                padding: context.paddingAllMedium,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: context.borderRadiusAllMedium,
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    width: context.cLowValue / 4,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                      size: context.cMediumValue,
                    ),
                    SizedBox(width: context.cLowValue),
                    Expanded(
                      child: Text(
                        'Eklediğiniz kelimeler güvenli bir şekilde kaydedilir ve tüm cihazlarınızda senkronize olur.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeaningData {
  String partOfSpeech;
  List<String> definitions;

  MeaningData({required this.partOfSpeech, required this.definitions});
}
