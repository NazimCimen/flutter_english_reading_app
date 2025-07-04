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
            NavigatorService.pushNamed(AppRoutes.addWordView, arguments: word);
          case 'delete':
            CustomDialogs.showWordDeleteConfirmation(context, provider);
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
}
