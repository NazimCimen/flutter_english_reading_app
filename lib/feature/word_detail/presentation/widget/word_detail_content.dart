import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';

class WordDetailContent extends StatefulWidget {
  final String word;
  final DictionaryEntry? wordDetail;
  final VoidCallback? onWordSaved;
  final bool isWordSaved;

  const WordDetailContent({
    super.key,
    required this.word,
    this.wordDetail,
    this.onWordSaved,
    this.isWordSaved = false,
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
    tts.setLanguage('en-US');
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
          _buildDragHandle(),
          _buildWordHeader(),
          SizedBox(height: context.cLowValue),
          _buildActionButtons(),
          if (widget.wordDetail != null) ...[
            SizedBox(height: context.cMediumValue),
            _buildWordDetails(),
          ],
          SizedBox(height: context.cXLargeValue),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: context.cXLargeValue,
        height: context.cLowValue / 2,
        margin: EdgeInsets.only(bottom: context.cLargeValue),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: context.borderRadiusAllXLow,
        ),
      ),
    );
  }

  Widget _buildWordHeader() {
    return Center(
      child: Text(
        widget.word,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          onPressed: () async {
            await tts.speak(widget.word);
          },
          icon: const Icon(Icons.volume_up_rounded),
          tooltip: 'Sesli Oku',
        ),
        if (!widget.isWordSaved) ...[
          SizedBox(width: context.cMediumValue),
          IconButton.filled(
            onPressed: () async {
              // TODO: Implement save word functionality
              widget.onWordSaved?.call();
            },
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Kelimeyi Kaydet',
          ),
        ],
      ],
    );
  }

  Widget _buildWordDetails() {
    final entry = widget.wordDetail!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entry.origin != null && entry.origin!.isNotEmpty) ...[
          _buildOriginSection(entry.origin!),
          SizedBox(height: context.cMediumValue),
        ],
        ...entry.meanings.map((meaning) => _MeaningSection(meaning: meaning)),
      ],
    );
  }

  Widget _buildOriginSection(String origin) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.history_edu_rounded,
          color: Theme.of(context).colorScheme.outlineVariant,
          size: context.cLargeValue,
        ),
        SizedBox(width: context.cLowValue),
        Expanded(
          child: Text(
            origin,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outlineVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

class _MeaningSection extends StatelessWidget {
  final Meaning meaning;

  const _MeaningSection({required this.meaning});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.label_important_outline,
              color: Theme.of(context).colorScheme.secondary,
              size: context.cMediumValue,
            ),
            SizedBox(width: context.cLowValue / 2),
            Text(
              meaning.partOfSpeech,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        SizedBox(height: context.cLowValue / 2),
        ...meaning.definitions.map(
          (def) => _DefinitionSection(definition: def),
        ),
        SizedBox(height: context.cMediumValue),
      ],
    );
  }
}

class _DefinitionSection extends StatelessWidget {
  final Definition definition;

  const _DefinitionSection({required this.definition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: context.cLowValue,
        bottom: context.cLowValue,
      ),
      padding: context.paddingAllLow,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.borderRadiusAllLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.definition,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          if (definition.example != null && definition.example!.isNotEmpty) ...[
            SizedBox(height: context.cLowValue / 2),
            Row(
              children: [
                Icon(
                  Icons.format_quote,
                  size: context.cMediumValue,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: context.cLowValue / 2),
                Expanded(
                  child: Text(
                    '"${definition.example!}"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (definition.synonyms != null &&
              definition.synonyms!.isNotEmpty) ...[
            SizedBox(height: context.cLowValue / 2),
            Wrap(
              spacing: context.cLowValue / 2,
              runSpacing: context.cLowValue / 4,
              children:
                  definition.synonyms!
                      .map(
                        (syn) => Chip(
                          label: Text(syn),
                          backgroundColor: AppColors.green.withOpacity(0.1),
                          labelStyle: TextStyle(color: AppColors.green),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
            ),
          ],
          if (definition.antonyms != null &&
              definition.antonyms!.isNotEmpty) ...[
            SizedBox(height: context.cLowValue / 2),
            Wrap(
              spacing: context.cLowValue / 2,
              runSpacing: context.cLowValue / 4,
              children:
                  definition.antonyms!
                      .map(
                        (ant) => Chip(
                          label: Text(ant),
                          backgroundColor: Colors.red.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.red),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
