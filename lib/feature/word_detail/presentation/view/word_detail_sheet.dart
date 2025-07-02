import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/feature/word_detail/presentation/widget/word_detail_content.dart';
import 'package:english_reading_app/feature/word_detail/presentation/widget/word_detail_shimmer.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.cLargeValue),
          topRight: Radius.circular(context.cLargeValue),
        ),
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

          return Consumer<MainLayoutViewModel>(
            builder: (context, mainLayoutViewModel, child) {
              return WordDetailContent(
                word: widget.word,
                wordDetail: viewModel.wordDetail,
                onWordSaved: widget.onWordSaved,
                isWordSaved: viewModel.isSaved,
                isMailVerified: mainLayoutViewModel.isMailVerified,
                onSaveWord: () async {
                  if (!mainLayoutViewModel.hasAccount) {
                    CustomSnackBars.showCustomTopScaffoldSnackBar(
                      context: context,
                      text:
                          'Kelime kaydetmek için hesap açmalısınız.',
                      icon: Icons.error_outline,
                    );
                    return;
                  }
                  
                  if (!mainLayoutViewModel.isMailVerified) {
                    CustomSnackBars.showCustomTopScaffoldSnackBar(
                      context: context,
                      text:
                          'Kelime kaydetmek için e-posta adresinizi doğrulayın.',
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  await viewModel.saveWord(widget.word);
                  widget.onWordSaved?.call();

                  // Show success message
                  if (context.mounted) {
                    CustomSnackBars.showCustomTopScaffoldSnackBar(
                      context: context,
                      text: 'Kelime başarıyla kaydedildi!',
                      icon: Icons.check_circle,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
