import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/feature/word_bank/mixin/add_word_mixin.dart';
import 'package:english_reading_app/feature/word_bank/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_bank/word_model.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
part '../widget/tag_selector.dart';

class AddWordView extends StatefulWidget {
  final WordModel? existingWord;
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

  Padding newMethod(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('None'),
            onTap: () {
              setState(() => selectedTag = null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Work'),
            onTap: () {
              setState(() => selectedTag = 'Work');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Add New Tag'),
            leading: const Icon(Icons.add),
            onTap: () async {
              Navigator.pop(context);
              final tag = await showDialog<String>(
                context: context,
                builder: (context) {
                  String newTag = '';
                  Color selectedColor = Colors.blue;
                  return AlertDialog(
                    title: const Text('Add New Tag'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Tag Name',
                          ),
                          onChanged: (value) => newTag = value,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Select Color:'),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => selectedColor = Colors.red,
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => selectedColor = Colors.green,
                              child: const CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => selectedColor = Colors.orange,
                              child: const CircleAvatar(
                                backgroundColor: Colors.orange,
                                radius: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, newTag),
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
              if (tag != null && tag.isNotEmpty) {
                setState(() => selectedTag = tag);
              }
            },
          ),
        ],
      ),
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
        title: Text(widget.existingWord == null ? 'Add Word' : 'Edit Word'),
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
                decoration: const InputDecoration(labelText: 'Word (Term)'),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter a word'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: definitionController,
                decoration: const InputDecoration(
                  labelText: 'Definition (back side)',
                ),
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
                  'Add Another Word',
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
