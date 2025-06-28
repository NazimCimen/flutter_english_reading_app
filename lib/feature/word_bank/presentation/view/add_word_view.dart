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
  final List<MeaningData> _meanings = [];
  final List<TextEditingController> _definitionControllers = [];
  final List<TextEditingController> _partOfSpeechControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeMeanings();
  }

  void _initializeMeanings() {
    if (widget.existingWord != null) {
      // Mevcut kelimeyi düzenleme modu
      for (final meaning in widget.existingWord!.meanings) {
        _partOfSpeechControllers.add(TextEditingController(text: meaning.partOfSpeech));
        for (final definition in meaning.definitions) {
          _definitionControllers.add(TextEditingController(text: definition.definition));
        }
        _meanings.add(MeaningData(
          partOfSpeech: meaning.partOfSpeech,
          definitions: meaning.definitions.map((d) => d.definition).toList(),
        ));
      }
    } else {
      // Yeni kelime ekleme modu - varsayılan olarak bir meaning ekle
      _addMeaning();
    }
  }

  void _addMeaning() {
    setState(() {
      _partOfSpeechControllers.add(TextEditingController());
      _meanings.add(MeaningData(partOfSpeech: '', definitions: []));
    });
  }

  void _removeMeaning(int index) {
    if (_meanings.length > 1) {
      setState(() {
        _partOfSpeechControllers.removeAt(index);
        _meanings.removeAt(index);
      });
    }
  }

  void _addDefinition(int meaningIndex) {
    setState(() {
      _definitionControllers.add(TextEditingController());
      _meanings[meaningIndex].definitions.add('');
    });
  }

  void _removeDefinition(int meaningIndex, int definitionIndex) {
    if (_meanings[meaningIndex].definitions.length > 1) {
      setState(() {
        _definitionControllers.removeAt(_getDefinitionControllerIndex(meaningIndex, definitionIndex));
        _meanings[meaningIndex].definitions.removeAt(definitionIndex);
      });
    }
  }

  int _getDefinitionControllerIndex(int meaningIndex, int definitionIndex) {
    int controllerIndex = 0;
    for (int i = 0; i < meaningIndex; i++) {
      controllerIndex += _meanings[i].definitions.length;
    }
    return controllerIndex + definitionIndex;
  }

  @override
  void dispose() {
    for (final controller in _definitionControllers) {
      controller.dispose();
    }
    for (final controller in _partOfSpeechControllers) {
      controller.dispose();
    }
    super.dispose();
  }

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

              // Anlamlar bölümü
              _buildMeaningsSection(),

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

  Widget _buildMeaningsSection() {
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
              onPressed: _addMeaning,
              icon: Icon(Icons.add, size: context.cMediumValue),
              label: Text('Anlam Ekle'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: context.cMediumValue),
        ...List.generate(_meanings.length, (meaningIndex) => 
          _buildMeaningCard(meaningIndex),
        ),
      ],
    );
  }

  Widget _buildMeaningCard(int meaningIndex) {
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
                  controller: _partOfSpeechControllers[meaningIndex],
                  decoration: CustomInputDecoration.inputDecoration(
                    context: context,
                    hintText: 'Örnek: noun, verb, adjective',
                  ).copyWith(
                    labelText: 'Kelime Türü',
                    prefixIcon: Icon(Icons.category),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen kelime türünü girin';
                    }
                    return null;
                  },
                ),
              ),
              if (_meanings.length > 1) ...[
                SizedBox(width: context.cLowValue),
                IconButton(
                  onPressed: () => _removeMeaning(meaningIndex),
                  icon: Icon(Icons.delete_outline, color: Colors.red),
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
                onPressed: () => _addDefinition(meaningIndex),
                icon: Icon(Icons.add, size: context.cLowValue),
                label: Text('Tanım Ekle'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.cLowValue),
          ...List.generate(_meanings[meaningIndex].definitions.length, (definitionIndex) =>
            _buildDefinitionField(meaningIndex, definitionIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionField(int meaningIndex, int definitionIndex) {
    final controllerIndex = _getDefinitionControllerIndex(meaningIndex, definitionIndex);
    
    return Container(
      margin: context.paddingVertBottomLow,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _definitionControllers[controllerIndex],
              decoration: CustomInputDecoration.inputDecoration(
                context: context,
                hintText: 'Kelimenin anlamını girin',
              ).copyWith(
                labelText: 'Tanım ${definitionIndex + 1}',
                prefixIcon: Icon(Icons.translate),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen tanımı girin';
                }
                return null;
              },
            ),
          ),
          if (_meanings[meaningIndex].definitions.length > 1) ...[
            SizedBox(width: context.cLowValue),
            IconButton(
              onPressed: () => _removeDefinition(meaningIndex, definitionIndex),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red),
              tooltip: 'Tanımı Sil',
            ),
          ],
        ],
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
      // Meanings listesini oluştur
      final meanings = <Meaning>[];
      int controllerIndex = 0;
      
      for (int i = 0; i < _meanings.length; i++) {
        final partOfSpeech = _partOfSpeechControllers[i].text.trim();
        final definitions = <Definition>[];
        
        for (int j = 0; j < _meanings[i].definitions.length; j++) {
          final definition = _definitionControllers[controllerIndex].text.trim();
          definitions.add(Definition(definition: definition));
          controllerIndex++;
        }
        
        meanings.add(Meaning(
          partOfSpeech: partOfSpeech,
          definitions: definitions,
        ));
      }

      if (widget.existingWord == null) {
        // Yeni kelime ekleme
        final newWord = DictionaryEntry(
          documentId: null,
          word: wordController.text.trim().toLowerCase(),
          meanings: meanings,
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
          meanings: meanings,
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

class MeaningData {
  String partOfSpeech;
  List<String> definitions;

  MeaningData({
    required this.partOfSpeech,
    required this.definitions,
  });
}
