part of '../view/word_detail_sheet.dart';

class _ErrorWidget extends StatelessWidget {
  final WordDetailViewModel viewModel;
  final String word;
  final WordDetailSource source;

  const _ErrorWidget({
    required this.viewModel,
    required this.word,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 48,
            color: Colors.red[400],
          ),
          SizedBox(height: context.cMediumValue),
          Text(
            'Bir şeyler yanlış gitti',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: context.cLowValue),
          Text(
            'Lütfen tekrar deneyin.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:Theme.of(context).colorScheme.outlineVariant,
                ),
          ),
          SizedBox(height: context.cMediumValue),
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: context.cBorderRadiusAllLow,
                  ),
                  elevation: 0,
                  padding: context.paddingVertAllLow,
                ),
                onPressed: () {
                  viewModel.loadWordDetail(
                    word: word,
                    source: source,
                  );
                },
                child: const Text('Tekrar Dene'),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 