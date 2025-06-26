import 'dart:ui';

import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/feature/article_detail/presentation/view/span_builder.dart';
import 'package:english_reading_app/feature/article_detail/presentation/widget/word_detail_sheet.dart';
import 'package:english_reading_app/product/componets/custom_sheets.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/enum/image_enum.dart';
import 'package:english_reading_app/feature/article_detail/presentation/viewmodel/article_detail_view_model.dart';
import 'package:english_reading_app/feature/article_detail/presentation/widget/article_detail_header.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
part '../widget/article_detail_appbar.dart';
part '../widget/bottom_control_bar.dart';
part '../widget/float_action_play_button.dart';

class ArticleDetailView extends StatelessWidget {
  final ArticleModel? article;
  const ArticleDetailView({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) =>
              ArticleDetailViewModel()
                ..setArticle(article)
                ..initTts(),
      child: const _ArticleDetailViewBody(),
    );
  }
}

class _ArticleDetailViewBody extends StatelessWidget {
  const _ArticleDetailViewBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleDetailViewModel>(
      builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: const _NewsDetailAppBar(),
          extendBody: true,
          bottomNavigationBar:
              viewmodel.isTextMaySpeakable && viewmodel.isMediaSection
                  ? const SafeArea(child: _BottomControlBar())
                  : null,
          floatingActionButton:
              viewmodel.isTextMaySpeakable && !viewmodel.isMediaSection
                  ? const _FloatActionPlayButton()
                  : null,
          body: Padding(
            padding: context.paddingHorizAllLow * 1.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: context.cMediumValue),

                  const ArticleDetailHeader(),
                  SizedBox(height: context.cMediumValue),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: viewmodel.fontSize,
                        height: 2.5,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children:
                          TextSpanBuilder(
                            fullText: viewmodel.article?.text ?? '',
                            context: context,
                            fontSize: viewmodel.fontSize,
                            highlightStart: //viewmodel.currentWordStart,
                                viewmodel.isPlaying || viewmodel.isContinued
                                    ? viewmodel.currentWordStart
                                    : null,
                            highlightEnd: //viewmodel.currentWordEnd,
                                viewmodel.isPlaying || viewmodel.isContinued
                                    ? viewmodel.currentWordEnd
                                    : null,
                            onWordTap: (word) async {
                              await viewmodel.pause();
                              _showWordDetailSheet(context, word);
                            },
                          ).build(),
                    ),
                  ),
                  SizedBox(height: context.dynamicHeight(0.15)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// bu methodu düzgün  bir şekilde dökümante et.
  List<TextSpan> _buildHighlightedText(
    ArticleDetailViewModel viewModel,
    BuildContext context,
  ) {
    final fullText = viewModel.article?.text ?? '';
    final spans = <TextSpan>[];

    /// heighlig tan önceki kısmı kelimlelerine ayırır
    final beforeHl = fullText.substring(0, viewModel.currentWordStart);
    final wordsbeforeHl = beforeHl.split(' ');

    /// heighlig tan sonraki kısmı kelimlelerine ayırır
    final afterHl = fullText.substring(viewModel.currentWordEnd);
    final wordsafterHl = afterHl.split(' ');

    // Önceki kısım (normal)
    spans
      ..add(
        TextSpan(
          children:
              wordsbeforeHl.map((word) {
                return TextSpan(
                  text: '$word ', // boşluk önemli!

                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () async {
                          await viewModel.pause();
                          _showWordDetailSheet(context, word);
                        },
                );
              }).toList(),
        ),
      )
      // Şu anki kelime (vurgulu)
      ..add(
        TextSpan(
          text: fullText.substring(
            viewModel.currentWordStart,
            viewModel.currentWordEnd,
          ),
          style: TextStyle(
            backgroundColor: AppColors.primaryColorSoft,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: viewModel.fontSize,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  await viewModel.pause();
                  _showWordDetailSheet(
                    context,
                    fullText.substring(
                      viewModel.currentWordStart,
                      viewModel.currentWordEnd,
                    ),
                  ); // ← Sheet açılır
                },
        ),
      )
      ..add(
        TextSpan(
          children:
              wordsafterHl.map((word) {
                return TextSpan(
                  text: '$word ',
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () async {
                          await viewModel.pause();
                          _showWordDetailSheet(context, word);
                        },
                );
              }).toList(),
        ),
      );

    return spans;
  }

  void _showWordDetailSheet(BuildContext context, String word) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WordDetailSheet(word: word),
    );
  }
}

/*
  /// bu methodu düzgün  bir şekilde dökümante et.
  List<TextSpan> _buildHighlightedText(
    ArticleDetailViewModel viewModel,
    BuildContext context,
  ) {
    final fullText = viewModel.article?.text ?? '';
    final spans = <TextSpan>[];

    final beforeHl = fullText.substring(0, viewModel.currentWordStart);
    final wordsbeforeHl = beforeHl.split(' ');

    final afterHl = fullText.substring(0, viewModel.currentWordStart);
    final wordsafterHl = afterHl.split(' ');

    if (viewModel.isPlaying || viewModel.isContinued) {
      // Önceki kısım (normal)
      spans
        ..add(
          TextSpan(
            //  text: fullText.substring(0, viewModel.currentWordStart),
            children:
                wordsbeforeHl.map((word) {
                  return TextSpan(
                    text: '$word ', // boşluk önemli!

                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () async {
                            await viewModel.pause();
                            _showWordDetailSheet(context, word);
                          },
                  );
                }).toList(),
          ),
        )
        // Şu anki kelime (vurgulu)
        ..add(
          TextSpan(
            text: fullText.substring(
              viewModel.currentWordStart,
              viewModel.currentWordEnd,
            ),
            style: TextStyle(
              backgroundColor: AppColors.primaryColorSoft,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: viewModel.fontSize,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () async {
                    await viewModel.pause(); // ← TTS duraklatılır
                    _showWordDetailSheet(
                      context,
                      fullText.substring(
                        viewModel.currentWordStart,
                        viewModel.currentWordEnd,
                      ),
                    ); // ← Sheet açılır
                  },
          ),
        )
        // Sonraki kısım (normal)
        ..add(
          TextSpan(
            text: fullText.substring(viewModel.currentWordEnd),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () async {
                    await viewModel.pause(); // ← TTS duraklatılır
                    _showWordDetailSheet(
                      context,
                      fullText.substring(viewModel.currentWordEnd),
                    ); // ← Sheet açılır
                  },
          ),
        );
    } else {
      // Normal metin (vurgu yok)
      spans.add(
        TextSpan(
          text: fullText,
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  await viewModel.pause(); // ← TTS duraklatılır
                  _showWordDetailSheet(context, ''); // ← Sheet açılır
                },
        ),
      );
    }

    return spans;
  }
*/
