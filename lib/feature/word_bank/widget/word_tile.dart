part of '../view/word_bank_view.dart';

class _WordTile extends StatelessWidget {
  final WordModel word;

  const _WordTile({required this.word});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewmodel>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          word.word,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        subtitle: word.definition != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  word.definition!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              )
            : null,
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.orange[700]),
              onPressed: () => NavigatorService.pushNamed(
                AppRoutes.addWordView,
                arguments: word,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => provider.deleteWord(word.id),
            ),
          ],
        ),
      ),
    );
  }
}
