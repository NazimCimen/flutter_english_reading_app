part of 'word_tile.dart';

class _WordCardPopup extends StatelessWidget {
  const _WordCardPopup({required this.word, required this.provider});

  final DictionaryEntry word;
  final WordBankViewModel provider;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: context.cMediumValue,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            context.read<AddWordViewModel>().cleanMeanings();
            NavigatorService.pushNamed(AppRoutes.addWordView, arguments: word);
          case 'delete':
            _deleteWordDialog(context);
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: context.cMediumValue),
                  SizedBox(width: context.cLowValue),
                  Text(
                    'Düzenle',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: context.cMediumValue,
                    color: AppColors.red,
                  ),
                  SizedBox(width: context.cLowValue),
                  Text(
                    'Sil',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.red),
                  ),
                ],
              ),
            ),
          ],
    );
  }

  Future<void> _deleteWordDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Kelimeyi Sil',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '${word.word}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' kelimesini silmek istediğinizden emin misiniz?',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'İptal',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await provider.deleteWord(word.documentId);
                },
                child: Text(
                  'Sil',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.red),
                ),
              ),
            ],
          ),
    );
  }
}
