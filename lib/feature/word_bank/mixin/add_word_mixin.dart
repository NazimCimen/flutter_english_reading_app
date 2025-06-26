import 'package:english_reading_app/feature/word_bank/view/add_word_view.dart';
import 'package:english_reading_app/feature/word_bank/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_bank/word_model.dart';
import 'package:flutter/material.dart';

mixin AddWordMixin on State<AddWordView> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController wordController;
  late TextEditingController definitionController;
  late TextEditingController tagController;
  String? selectedTag;

  @override
  void initState() {
    wordController = TextEditingController(
      text: widget.existingWord?.word ?? '',
    );
    definitionController = TextEditingController(
      text: widget.existingWord?.definition ?? '',
    );
    tagController = TextEditingController();
    selectedTag = null;

    super.initState();
  }

  @override
  void dispose() {
    wordController.dispose();
    definitionController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void onSavePressed(BuildContext context, WordBankViewmodel provider) {
    if (formKey.currentState!.validate()) {
      if (widget.existingWord == null) {
        provider.addWord(
          wordController.text.trim(),
          definition: definitionController.text.trim(),
        );
      } else {
        provider.updateWord(
          WordModel(
            id: widget.existingWord!.id,
            word: wordController.text.trim(),
            definition: definitionController.text.trim(),
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }
}
