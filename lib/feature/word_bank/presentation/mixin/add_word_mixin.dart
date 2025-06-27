import 'package:english_reading_app/feature/word_bank/presentation/view/add_word_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin AddWordMixin on State<AddWordView> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController wordController;
  late TextEditingController definitionController;

  @override
  void initState() {
    wordController = TextEditingController(
      text: widget.existingWord?.word ?? '',
    );
    definitionController = TextEditingController(
      text: widget.existingWord?.meanings.isNotEmpty == true &&
              widget.existingWord!.meanings.first.definitions.isNotEmpty
          ? widget.existingWord!.meanings.first.definitions.first.definition
          : '',
    );

    super.initState();
  }

  @override
  void dispose() {
    wordController.dispose();
    definitionController.dispose();
    super.dispose();
  }

  void onSavePressed(BuildContext context, WordBankViewmodel provider) {
    if (formKey.currentState!.validate()) {
      if (widget.existingWord == null) {
        final newWord = DictionaryEntry(
          documentId: null,
          word: wordController.text.trim(),
          meanings: definitionController.text.trim().isNotEmpty
              ? [
                  Meaning(
                    partOfSpeech: 'noun',
                    definitions: [
                      Definition(
                        definition: definitionController.text.trim(),
                      ),
                    ],
                  ),
                ]
              : [],
          phonetics: [],
        );
        provider.addWord(newWord);
        Navigator.of(context).pop();
      } else {
        final updatedWord = widget.existingWord!.copyWith(
          word: wordController.text.trim(),
          meanings: definitionController.text.trim().isNotEmpty
              ? [
                  Meaning(
                    partOfSpeech: 'noun',
                    definitions: [
                      Definition(
                        definition: definitionController.text.trim(),
                      ),
                    ],
                  ),
                ]
              : widget.existingWord!.meanings,
        );
        provider.updateWord(updatedWord);
        Navigator.of(context).pop();
      }
    }
  }
}
