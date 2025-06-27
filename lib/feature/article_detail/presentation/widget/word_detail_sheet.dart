import 'package:dartz/dartz.dart' show Either;
import 'package:dio/dio.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/services/dictionary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';

class WordDetailSheet extends StatefulWidget {
  final String word;
  final VoidCallback? onWordSaved;
  const WordDetailSheet({
    super.key, 
    required this.word,
    this.onWordSaved,
  });

  @override
  State<WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends State<WordDetailSheet> {
  late final DictionaryService _service;
  late Future<Either<Failure, List<DictionaryEntry>>> _future;
  late final FlutterTts tts;
  late final BaseFirebaseService<DictionaryEntry> _firebaseService;
  late final UserService _userService;

  @override
  void initState() {
    super.initState();
    tts = FlutterTts();
    tts.setLanguage('en-US');
    _service = DictionaryServiceImpl(Dio());
    _future = _service.getWordDetail(widget.word);
    _firebaseService = FirebaseServiceImpl<DictionaryEntry>(
      firestore: FirebaseFirestore.instance,
    );
    _userService = UserService();
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double halfScreenHeight = MediaQuery.of(context).size.height * 0.5;
    return FutureBuilder<Either<Failure, List<DictionaryEntry>>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: halfScreenHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: const _WordDetailShimmer(),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: snapshot.data!.fold(
            (failure) {
              // Sadece kelime, tts ve kaydet butonları görünsün
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.word,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        onPressed: () async {
                          await tts.speak(widget.word);
                        },
                        icon: const Icon(Icons.volume_up_rounded),
                        tooltip: 'Sesli Oku',
                      ),
                      const SizedBox(width: 12),
                      IconButton.filled(
                        onPressed: () async {
                          await _saveWord(widget.word);
                        },
                        icon: Icon(Icons.bookmark_add_outlined),
                        tooltip: 'Kelimeyi Kaydet',
                      ),
                    ],
                  ),
                  SizedBox(height: context.cXLargeValue),
                ],
              );
            },
            (entries) {
              final entry = entries.first;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        entry.word,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: () async {
                            await tts.speak(entry.word);
                          },
                          icon: const Icon(Icons.volume_up_rounded),
                          tooltip: 'Sesli Oku',
                        ),
                        const SizedBox(width: 12),
                        IconButton.filled(
                          onPressed: () async {
                            await _saveWord(entry.word);
                          },
                          icon: Icon(Icons.bookmark_add_outlined),
                          tooltip: 'Kelimeyi Kaydet',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (entry.origin != null && entry.origin!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.history_edu_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.origin!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    ...entry.meanings
                        .map((meaning) => _MeaningSection(meaning: meaning))
                        .toList(),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _saveWord(String word) async {
    try {
      debugPrint('=== _saveWord başladı: $word ===');
      final userId = _userService.getUserId();
      debugPrint('User ID: $userId');
      
      if (userId == null) {
        debugPrint('User ID is null, showing error message');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kullanıcı girişi yapılmamış'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Dictionary API'den kelime detaylarını al
      debugPrint('Getting word details from API...');
      final result = await _service.getWordDetail(word);

      if (result.isLeft()) {
        debugPrint('API failed, saving basic word');
        // API'den veri alınamadıysa sadece kelimeyi kaydet
        await _saveBasicWord(word, userId);
      } else {
        final entries = result.getOrElse(() => []);
        if (entries.isNotEmpty) {
          debugPrint('API success, saving full dictionary entry');
          final entry = entries.first;
          // Tam DictionaryEntry'yi kaydet
          await _saveFullDictionaryEntry(entry, userId);
        } else {
          debugPrint('API returned empty entries, saving basic word');
          // Sadece kelimeyi kaydet
          await _saveBasicWord(word, userId);
        }
      }
      debugPrint('=== _saveWord tamamlandı ===');
    } catch (e) {
      debugPrint('Kelime kaydetme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kelime kaydedilirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveBasicWord(String word, String userId) async {
    try {
      debugPrint('=== _saveBasicWord başladı: $word ===');
      final basicEntry = DictionaryEntry(
        documentId: null, // Firestore otomatik ID oluşturacak
        word: word,
        meanings: [],
        phonetics: [],
        userId: userId,
        createdAt: DateTime.now(),
      );

      debugPrint('Saving basic entry to Firestore...');
      final docId = await _firebaseService.addItem(
        FirebaseCollectionEnum.dictionary.name,
        basicEntry,
      );

      debugPrint('Basic word saved with documentId: $docId');

      // WordBankViewmodel'e kelimeyi ekle
      final wordWithId = basicEntry.copyWith(documentId: docId);
      final wordBankProvider = context.read<WordBankViewmodel>();
      wordBankProvider.addWordToLocalList(wordWithId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$word" kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
      
      debugPrint('Calling onWordSaved callback...');
      widget.onWordSaved?.call();
      debugPrint('=== _saveBasicWord tamamlandı ===');
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Temel kelime kaydetme hatası: $e');
      rethrow;
    }
  }

  Future<void> _saveFullDictionaryEntry(DictionaryEntry entry, String userId) async {
    try {
      debugPrint('=== _saveFullDictionaryEntry başladı: ${entry.word} ===');
      final entryWithUserId = entry.copyWith(
        documentId: null, // Firestore otomatik ID oluşturacak
        userId: userId,
        createdAt: DateTime.now(),
      );

      debugPrint('Saving full entry to Firestore...');
      final docId = await _firebaseService.addItem(
        FirebaseCollectionEnum.dictionary.name,
        entryWithUserId,
      );

      debugPrint('Full word saved with documentId: $docId');

      // WordBankViewmodel'e kelimeyi ekle
      final wordWithId = entryWithUserId.copyWith(documentId: docId);
      final wordBankProvider = context.read<WordBankViewmodel>();
      wordBankProvider.addWordToLocalList(wordWithId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${entry.word}" detaylarıyla birlikte kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
      
      debugPrint('Calling onWordSaved callback...');
      widget.onWordSaved?.call();
      debugPrint('=== _saveFullDictionaryEntry tamamlandı ===');
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Tam kelime kaydetme hatası: $e');
      rethrow;
    }
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
            const Icon(
              Icons.label_important_outline,
              color: Colors.blueGrey,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              meaning.partOfSpeech,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...meaning.definitions
            .map((def) => _DefinitionSection(definition: def))
            .toList(),
        const SizedBox(height: 12),
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
      margin: const EdgeInsets.only(left: 8, bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.definition,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[900],
              height: 1.5,
            ),
          ),
          if (definition.example != null && definition.example!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.format_quote,
                  size: 16,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '"${definition.example!}"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (definition.synonyms != null &&
              definition.synonyms!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 2,
              children:
                  definition.synonyms!
                      .map(
                        (syn) => Chip(
                          label: Text(syn),
                          backgroundColor: Colors.green[50],
                          labelStyle: const TextStyle(color: Colors.green),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
            ),
          ],
          if (definition.antonyms != null &&
              definition.antonyms!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 2,
              children:
                  definition.antonyms!
                      .map(
                        (ant) => Chip(
                          label: Text(ant),
                          backgroundColor: Colors.red[50],
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

class _WordDetailShimmer extends StatelessWidget {
  const _WordDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: ShimmerContainer(height: 32, width: 120, borderRadius: 8),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerContainer(height: 40, width: 40, borderRadius: 20),
              const SizedBox(width: 12),
              ShimmerContainer(height: 40, width: 40, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerContainer(height: 20, width: 20, borderRadius: 8),
              const SizedBox(width: 8),
              Expanded(
                child: ShimmerContainer(
                  height: 18,
                  width: double.infinity,
                  borderRadius: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(2, (i) => _ShimmerMeaningSection()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ShimmerMeaningSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShimmerContainer(height: 18, width: 18, borderRadius: 6),
            const SizedBox(width: 6),
            ShimmerContainer(height: 16, width: 60, borderRadius: 8),
          ],
        ),
        const SizedBox(height: 6),
        ...List.generate(2, (i) => _ShimmerDefinitionSection()),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _ShimmerDefinitionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(height: 14, width: double.infinity, borderRadius: 8),
          const SizedBox(height: 6),
          ShimmerContainer(height: 12, width: 120, borderRadius: 8),
          const SizedBox(height: 6),
          Row(
            children: [
              ...List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ShimmerContainer(
                    height: 20,
                    width: 40,
                    borderRadius: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerContainer({
    required this.height,
    required this.width,
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor: Theme.of(context).colorScheme.outline,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
