part of '../view/word_bank_view.dart';

class _SwipeWordCard extends StatelessWidget {
  final DictionaryEntry word;
  const _SwipeWordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewmodel>();

    return Card(
      elevation: 12,
      color: AppColors.primaryColorSoft,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusAllLarge,
      ),
      child: Padding(
        padding: context.paddingAllLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              word.word,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (word.phonetic != null && word.phonetic!.isNotEmpty) ...[
              SizedBox(height: context.cLowValue),
              Text(
                '/${word.phonetic!}/',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: context.cMediumValue),
            if (word.meanings.isNotEmpty && word.meanings.first.definitions.isNotEmpty)
              Expanded(
                child: Text(
                  word.meanings.first.definitions.first.definition,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ),
            SizedBox(height: context.cLargeValue),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () {
                    NavigatorService.pushNamed(
                      AppRoutes.addWordView,
                      arguments: word,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () => provider.deleteWord(word.documentId!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 