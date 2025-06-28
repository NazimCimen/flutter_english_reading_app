import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/feature/word_detail/presentation/widget/word_detail_content.dart';
import 'package:english_reading_app/feature/word_detail/presentation/widget/word_detail_shimmer.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';

part '../widget/error_widget.dart';

class WordDetailSheet extends StatefulWidget {
  final String word;
  final WordDetailSource source;
  final VoidCallback? onWordSaved;

  const WordDetailSheet({
    required this.word,
    required this.source,
    this.onWordSaved,
    super.key,
  });

  @override
  State<WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends State<WordDetailSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<WordDetailViewModel>();
      await viewModel.loadWordDetail(word: widget.word, source: widget.source);
    });
  }

  @override
  Widget build(BuildContext context) {
    final halfScreenHeight = MediaQuery.of(context).size.height * 0.5;

    return Container(
      height: halfScreenHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.cBorderRadiusAllLarge,
      ),
      child: Consumer<WordDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const WordDetailShimmer();
          }

          if (viewModel.errorMessage != null) {
            return _ErrorWidget(
              viewModel: viewModel,
              word: widget.word,
              source: widget.source,
            );
          }

          return WordDetailContent(
            word: widget.word,
            wordDetail: viewModel.wordDetail,
            onWordSaved: widget.onWordSaved,
            isWordSaved: viewModel.isSaved,
          );
        },
      ),
    );
  }
}
