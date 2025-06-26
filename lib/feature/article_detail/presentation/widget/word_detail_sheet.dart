import 'package:dartz/dartz.dart' show Either;
import 'package:dio/dio.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/services/dictionary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class WordDetailSheet extends StatefulWidget {
  final String word;
  const WordDetailSheet({super.key, required this.word});

  @override
  State<WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends State<WordDetailSheet> {
  late final DictionaryService _service;
  late Future<Either<Failure, List<DictionaryEntry>>> _future;
  final tts = FlutterTts();
  @override
  void initState() {
    super.initState();
    _service = DictionaryServiceImpl(Dio());
    _future = _service.getWordDetail(widget.word);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: FutureBuilder<Either<Failure, List<DictionaryEntry>>>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return snapshot.data!.fold(
              (failure) => Center(child: Text('Hata: ${failure.errorMessage}')),
              (entries) {
                final entry = entries.first;
                final phonetic = entry.phonetic ?? '';
                final definition =
                    entry.meanings.first.definitions.first.definition;
                final audioUrl =
                    entry.phonetics
                        .firstWhere(
                          (e) => e.audio != null && e.audio!.isNotEmpty,
                          orElse: () => Phonetic(),
                        )
                        .audio;

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
                        entry.word,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (audioUrl != null && audioUrl.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            onPressed: () async {
                           await   tts.speak('text');
   
                            },
                            icon: const Icon(Icons.volume_up_rounded),
                            tooltip: 'Sesli Oku',
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (phonetic.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.record_voice_over_rounded,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '/$phonetic/',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            definition,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          _saveWord(entry.word);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${entry.word}" kaydedildi'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bookmark_add_outlined),
                        label: const Text('Kelimeyi Kaydet'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _saveWord(String word) {
    debugPrint('Kaydedildi: $word');
    // burada Firestore, Hive vs. entegre edebilirsin.
  }
}
