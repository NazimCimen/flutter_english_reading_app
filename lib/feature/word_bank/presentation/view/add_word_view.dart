import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/presentation/mixin/add_word_mixin.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/decorations/input_decorations/custom_input_decoration.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';

class AddWordView extends StatefulWidget {
  final DictionaryEntry? existingWord;
  const AddWordView({super.key, this.existingWord});

  @override
  State<AddWordView> createState() => _AddWordViewState();
}

class _AddWordViewState extends State<AddWordView> with AddWordMixin {
  bool _isLoading = false;

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
          if (_isLoading)
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
              onPressed: () => _onSavePressed(context, provider),
            ),
        ],
      ),
      body: Padding(
        padding: context.paddingAllMedium,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              // Kelime alanı
              TextFormField(
                controller: wordController,
                decoration: CustomInputDecoration.inputDecoration(
                  context: context,
                  hintText: 'Örnek: apple, beautiful, happiness',
                ).copyWith(
                  labelText: 'Kelime',
                  prefixIcon: Icon(Icons.text_fields),
                ),
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen bir kelime girin';
                  }
                  if (value.trim().length < 2) {
                    return 'Kelime en az 2 karakter olmalıdır';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.cMediumValue),

              // Anlam alanı
              TextFormField(
                controller: definitionController,
                decoration: CustomInputDecoration.inputDecoration(
                  context: context,
                  hintText: 'Kelimenin Türkçe anlamını girin',
                ).copyWith(
                  labelText: 'Anlam',
                  prefixIcon: Icon(Icons.translate),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen kelimenin anlamını girin';
                  }
                  return null;
                },
              ),

              SizedBox(height: context.cXLargeValue),

              // Kaydet butonu
              ElevatedButton(
                onPressed:
                    _isLoading ? null : () => _onSavePressed(context, provider),
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
                    _isLoading
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: context.cMediumValue,
                              height: context.cMediumValue,
                              child: CircularProgressIndicator(
                                strokeWidth: context.cLowValue / 4,
                                valueColor: AlwaysStoppedAnimation<Color>(
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
                        'Eklediğiniz kelimeler Firestore\'a kaydedilir ve tüm cihazlarınızda senkronize olur.',
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

  Future<void> _onSavePressed(
    BuildContext context,
    WordBankViewmodel provider,
  ) async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.existingWord == null) {
        // Yeni kelime ekleme
        final newWord = DictionaryEntry(
          documentId: null,
          word: wordController.text.trim().toLowerCase(),
          meanings: [
            Meaning(
              partOfSpeech: 'noun',
              definitions: [
                Definition(definition: definitionController.text.trim()),
              ],
            ),
          ],
          phonetics: [],
          createdAt: DateTime.now(),
        );

        await provider.addWord(newWord);

        if (mounted) {
          CustomSnackBars.showCustomTopScaffoldSnackBar(
            context: context,
            text: '"${newWord.word}" kelimesi başarıyla eklendi!',
          );
          Navigator.of(context).pop();
        }
      } else {
        // Mevcut kelimeyi güncelleme
        final updatedWord = widget.existingWord!.copyWith(
          word: wordController.text.trim().toLowerCase(),
          meanings: [
            Meaning(
              partOfSpeech: 'noun',
              definitions: [
                Definition(definition: definitionController.text.trim()),
              ],
            ),
          ],
        );

        await provider.updateWord(updatedWord);

        if (mounted) {
          CustomSnackBars.showCustomTopScaffoldSnackBar(
            context: context,
            text: '"${updatedWord.word}" kelimesi başarıyla güncellendi!',
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBars.showCustomTopScaffoldSnackBar(
          context: context,
          text: 'Hata oluştu: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
