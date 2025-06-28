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
    return Padding(
      padding: context.paddingAllLarge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline, 
            size: context.cXLargeValue, 
            color: Colors.red[300]
          ),
          SizedBox(height: context.cMediumValue),
          Text(
            'Hata',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.red[700]),
          ),
          SizedBox(height: context.cLowValue),
          Text(
            viewModel.errorMessage ?? 'Bilinmeyen hata',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          SizedBox(height: context.cLargeValue),
          ElevatedButton(
            onPressed: () {
              viewModel.loadWordDetail(
                word: word,
                source: source,
              );
            },
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
} 