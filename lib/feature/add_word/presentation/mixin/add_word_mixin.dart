import 'package:english_reading_app/feature/add_word/presentation/view/add_word_view.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin AddWordMixin on State<AddWordView> {
  late TextEditingController _wordController;
  TextEditingController get wordControllerInstance => _wordController;
  final formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKeyInstance => formKey;

  final List<Meaning> _meanings = [];
  List<Meaning> get meanings => _meanings;

  //mapi iki parçaya ayır tür ve anlam listesi

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(
      text: widget.existingWord?.word ?? '',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddWordViewModel>().setMeanings(
        widget.existingWord?.meanings ?? [],
      );
    });
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  /*
  void _initializeControllerAndMeaningList(String? initialWord) {
    _wordController = TextEditingController(text: initialWord ?? '');
    // Initialize controllers based on existing meanings FIRST
    if (widget.existingWord?.meanings != null) {
      for (final meaning in widget.existingWord!.meanings!) {
        _partOfSpeechControllers.add(
          TextEditingController(text: meaning.partOfSpeech),
        );
        for (final definition in meaning.definitions) {
          _definitionControllers.add(
            TextEditingController(text: definition.definition),
          );
        }
        _meanings.add(
          Meaning(
            partOfSpeech: meaning.partOfSpeech,
            definitions: meaning.definitions,
          ),
        );
      }
    } else {
      _addInitialMeaning();
    }
  }

  void _addInitialMeaning() {
    _partOfSpeechControllers.add(TextEditingController());
    _definitionControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _wordController.dispose();
    for (final controller in _definitionControllers) {
      controller.dispose();
    }
    for (final controller in _partOfSpeechControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addMeaning() {
    setState(() {
      _partOfSpeechControllers.add(TextEditingController());
      _meanings.add(Meaning(partOfSpeech: '', definitions: []));
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
      _meanings[meaningIndex].definitions.add(Definition(definition: ''));
    });
  }

  void removeDefinition(int meaningIndex, int definitionIndex) {
    if (_meanings[meaningIndex].definitions.length > 1) {
      setState(() {
        _definitionControllers.removeAt(
          _getDefinitionControllerIndex(meaningIndex, definitionIndex),
        );
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

  Future<void> onSavePressed(
    BuildContext context,
    WordBankViewModel provider,
    DictionaryEntry? existingWord,
  ) async {
    if (!formKey.currentState!.validate()) return;

    setLoading(true);

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

      meanings.add(
        Meaning(partOfSpeech: partOfSpeech, definitions: definitions),
      );
    }

    if (existingWord == null) {
      // Yeni kelime ekleme
      final newWord = DictionaryEntry(
        documentId: null,
        word: _wordController.text.trim().toLowerCase(),
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
        word: _wordController.text.trim().toLowerCase(),
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
      setLoading(false);
    }
  }


*/
}
