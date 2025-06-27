part of '../view/word_bank_view.dart';

class WordBankDetailSheet extends StatelessWidget {
  final DictionaryEntry word;
  final VoidCallback? onWordDeleted;
  final VoidCallback? onWordEdited;

  const WordBankDetailSheet({
    super.key,
    required this.word,
    this.onWordDeleted,
    this.onWordEdited,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Word header
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _editWord(context),
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Düzenle',
                ),
                IconButton(
                  onPressed: () => _deleteWord(context),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Sil',
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Word details
            if (word.meanings.isNotEmpty) ...[
              ...word.meanings.map((meaning) => _MeaningSection(meaning: meaning)),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bu kelime için detaylı anlam bilgisi bulunmuyor.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Creation date
            if (word.createdAt != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Eklenme: ${_formatDate(word.createdAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _editWord(BuildContext context) {
    Navigator.of(context).pop();
    NavigatorService.pushNamed(
      AppRoutes.addWordView,
      arguments: word,
    );
    onWordEdited?.call();
  }

  void _deleteWord(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kelimeyi Sil'),
        content: Text('"${word.word}" kelimesini silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              final provider = Provider.of<WordBankViewmodel>(
                context, 
                listen: false,
              );
              if (word.documentId != null) {
                provider.deleteWord(word.documentId!);
              }
              onWordDeleted?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _MeaningSection extends StatelessWidget {
  final Meaning meaning;
  
  const _MeaningSection({required this.meaning});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.label_important_outline,
              color: Colors.blueGrey,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              meaning.partOfSpeech,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...meaning.definitions.map((def) => _DefinitionSection(definition: def)),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _DefinitionSection extends StatelessWidget {
  final Definition definition;
  
  const _DefinitionSection({required this.definition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.definition,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[900],
              height: 1.5,
            ),
          ),
          if (definition.example != null && definition.example!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.format_quote,
                  size: 16,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '"${definition.example!}"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
} 