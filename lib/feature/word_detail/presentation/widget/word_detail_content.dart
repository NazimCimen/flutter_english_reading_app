import 'package:english_reading_app/config/localization/locale_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';

part 'word_detail_widgets.dart';

class WordDetailContent extends StatefulWidget {
  final String word;
  final DictionaryEntry? wordDetail;
  final VoidCallback? onWordSaved;
  final bool isWordSaved;
  final bool isMailVerified;
  final VoidCallback onSaveWord;

  const WordDetailContent({
    required this.word,
    this.wordDetail,
    this.onWordSaved,
    this.isWordSaved = false,
    required this.isMailVerified,
    required this.onSaveWord,
    super.key,
  });

  @override
  State<WordDetailContent> createState() => _WordDetailContentState();
}

class _WordDetailContentState extends State<WordDetailContent> {
  late final FlutterTts tts;

  @override
  void initState() {
    super.initState();
    tts = FlutterTts();
    tts.setLanguage(LocaleConstants.enLocale.languageCode);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.paddingAllMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _WordDetailDragHandle(),
          _WordDetailHeader(word: widget.word),
          SizedBox(height: context.cLowValue),
          _WordDetailActionButtons(
            word: widget.word,
            isWordSaved: widget.isWordSaved,
            onWordSaved: widget.onWordSaved,
            onSaveWord: widget.onSaveWord,
            tts: tts,
          ),
          if (widget.wordDetail != null) ...[
            SizedBox(height: context.cMediumValue),
            _WordDetailContent(wordDetail: widget.wordDetail!),
          ],
          SizedBox(height: context.cXLargeValue),
        ],
      ),
    );
  }
}
