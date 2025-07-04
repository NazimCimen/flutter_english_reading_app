import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:flutter/material.dart';

mixin AddWordMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  final List<MeaningData> _meanings = [];
  final List<TextEditingController> _definitionControllers = [];
  final List<TextEditingController> _partOfSpeechControllers = [];
  final formKey = GlobalKey<FormState>();
  late TextEditingController wordController;

  // Getters
  bool get isLoading => _isLoading;
  List<MeaningData> get meanings => _meanings;
  List<TextEditingController> get definitionControllers => _definitionControllers;
  List<TextEditingController> get partOfSpeechControllers => _partOfSpeechControllers;
  GlobalKey<FormState> get formKeyInstance => formKey;
  TextEditingController get wordControllerInstance => wordController;

  void initializeControllers(String? initialWord) {
    wordController = TextEditingController(text: initialWord ?? '');
    _initializeMeanings();
  }

  void _initializeMeanings() {
    // Bu method widget.existingWord'a erişemediği için
    // initializeMeanings method'u view'da çağrılacak
  }

  void initializeMeanings(DictionaryEntry? existingWord) {
    if (existingWord != null) {
      // Mevcut kelimeyi düzenleme modu
      for (final meaning in existingWord.meanings!) {
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
      addMeaning();
    }
  }

  void addMeaning() {
    setState(() {
      _partOfSpeechControllers.add(TextEditingController());
      _meanings.add(MeaningData(partOfSpeech: '', definitions: []));
    });
  }

  void removeMeaning(int index) {
    if (_meanings.length > 1) {
      setState(() {
        _partOfSpeechControllers.removeAt(index);
        _meanings.removeAt(index);
      });
    }
  }

  void addDefinition(int meaningIndex) {
    setState(() {
      _definitionControllers.add(TextEditingController());
      _meanings[meaningIndex].definitions.add('');
    });
  }

  void removeDefinition(int meaningIndex, int definitionIndex) {
    if (_meanings[meaningIndex].definitions.length > 1) {
      setState(() {
        _definitionControllers.removeAt(_getDefinitionControllerIndex(meaningIndex, definitionIndex));
        _meanings[meaningIndex].definitions.removeAt(definitionIndex);
      });
    }
  }

  int _getDefinitionControllerIndex(int meaningIndex, int definitionIndex) {
    int controllerIndex = 0;
    for (var i = 0; i < meaningIndex; i++) {
      controllerIndex += _meanings[i].definitions.length;
    }
    return controllerIndex + definitionIndex;
  }

  int getDefinitionControllerIndex(int meaningIndex, int definitionIndex) {
    return _getDefinitionControllerIndex(meaningIndex, definitionIndex);
  }

  Future<void> onSavePressed(BuildContext context, WordBankViewModel provider, DictionaryEntry? existingWord) async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

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

    if (existingWord == null) {
      // Yeni kelime ekleme
      final newWord = DictionaryEntry(
        documentId: null,
        word: wordController.text.trim().toLowerCase(),
        meanings: meanings,
        phonetics: [],
        createdAt: DateTime.now(),
      );

    //  await provider.addWord(newWord);

      if (mounted) {
        CustomSnackBars.showCustomTopScaffoldSnackBar(
          context: context,
          text: '"${newWord.word}" kelimesi başarıyla eklendi!',
          icon: Icons.check_circle,
        );
        Navigator.of(context).pop();
      }
    } else {
      // Mevcut kelimeyi güncelleme
      final updatedWord = existingWord.copyWith(
        word: wordController.text.trim().toLowerCase(),
        meanings: meanings,
      );

   //   await provider.updateWord(updatedWord);

      if (mounted) {
        CustomSnackBars.showCustomTopScaffoldSnackBar(
          context: context,
          text: '"${updatedWord.word}" kelimesi başarıyla güncellendi!',
          icon: Icons.check_circle,
        );
        Navigator.of(context).pop();
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void disposeControllers() {
    for (final controller in _definitionControllers) {
      controller.dispose();
    }
    for (final controller in _partOfSpeechControllers) {
      controller.dispose();
    }
    wordController.dispose();
  }
}

class MeaningData {
  String partOfSpeech;
  List<String> definitions;

  MeaningData({required this.partOfSpeech, required this.definitions});
} 