import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/presentation/mixin/add_word_mixin.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part '../widget/tag_selector.dart';

class AddWordView extends StatefulWidget {
  final DictionaryEntry? existingWord;
  const AddWordView({super.key, this.existingWord});

  @override
  State<AddWordView> createState() => _AddWordViewState();
}

class _AddWordViewState extends State<AddWordView> with AddWordMixin {
  void _openTagSelectionSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return _TagSelector(
          selectedTag: selectedTag,
          onTagSelected: (tag) {
            setState(() {
              selectedTag = tag;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewmodel>();

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        title: Text(widget.existingWord == null ? 'Kelime Ekle' : 'Kelime Düzenle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => onSavePressed(context, provider),
          ),
        ],
      ),
      body: Padding(
        padding: context.cPaddingMedium,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: wordController,
                decoration: const InputDecoration(
                  labelText: 'Kelime',
                  hintText: 'Örnek: apple',
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Lütfen bir kelime girin'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: definitionController,
                decoration: const InputDecoration(
                  labelText: 'Anlam',
                  hintText: 'Kelimenin anlamını girin',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _openTagSelectionSheet,
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: selectedTag),
                    decoration: InputDecoration(
                      labelText: 'Tag',
                      hintText: selectedTag ?? 'None',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => onSavePressed(context, provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  widget.existingWord == null ? 'Kelime Ekle' : 'Güncelle',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
