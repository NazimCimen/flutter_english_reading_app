part of 'word_detail_content.dart';

/// Drag handle widget for the modal bottom sheet
class _WordDetailDragHandle extends StatelessWidget {
  const _WordDetailDragHandle();

  /// Builds the drag handle UI
  @override
  Widget build(BuildContext context) {
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
}

/// Header widget displaying the word title
class _WordDetailHeader extends StatelessWidget {
  final String word;

  const _WordDetailHeader({required this.word});

  /// Builds the word header UI
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        word,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// Action buttons widget for word operations (TTS and save)
class _WordDetailActionButtons extends StatelessWidget {
  final String word;
  final bool isWordSaved;
  final VoidCallback? onWordSaved;
  final VoidCallback onSaveWord;
  final FlutterTts tts;

  const _WordDetailActionButtons({
    required this.word,
    required this.isWordSaved,
    required this.onSaveWord,
    required this.tts,
    this.onWordSaved,
  });

  /// Builds the action buttons UI
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          onPressed: () async {
            await tts.speak(word);
          },
          icon: const Icon(Icons.volume_up_rounded),
          tooltip: StringConstants.speakWordAloud,
        ),
        if (!isWordSaved) ...[
          SizedBox(width: context.cMediumValue),
          IconButton.filled(
            onPressed: () async {
              onSaveWord();
            },
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: StringConstants.saveWord,
          ),
        ],
      ],
    );
  }
}

/// Main content widget displaying word details
class _WordDetailContent extends StatelessWidget {
  final DictionaryEntry wordDetail;

  const _WordDetailContent({required this.wordDetail});

  /// Builds the word detail content UI
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wordDetail.origin != null && wordDetail.origin!.isNotEmpty) ...[
          _WordDetailOriginSection(origin: wordDetail.origin!),
          SizedBox(height: context.cMediumValue),
        ],
        ...wordDetail.meanings!.map(
          (meaning) => _WordDetailMeaningSection(meaning: meaning),
        ),
      ],
    );
  }
}

/// Widget displaying word origin information
class _WordDetailOriginSection extends StatelessWidget {
  final String origin;

  const _WordDetailOriginSection({required this.origin});

  /// Builds the origin section UI
  @override
  Widget build(BuildContext context) {
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

/// Widget displaying word meaning section
class _WordDetailMeaningSection extends StatelessWidget {
  final Meaning meaning;

  const _WordDetailMeaningSection({required this.meaning});

  /// Builds the meaning section UI
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
          (def) => _WordDetailDefinitionSection(definition: def),
        ),
        SizedBox(height: context.cMediumValue),
      ],
    );
  }
}

/// Widget displaying individual definition with examples and synonyms
class _WordDetailDefinitionSection extends StatelessWidget {
  final Definition definition;

  const _WordDetailDefinitionSection({required this.definition});

  /// Builds the definition section UI
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
                          labelStyle: const TextStyle(color: AppColors.green),
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
