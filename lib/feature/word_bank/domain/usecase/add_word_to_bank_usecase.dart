import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';

class AddWordToBankUseCase {
  final WordBankRepository repository;

  AddWordToBankUseCase({required this.repository});

  Future<Either<Failure, String>> call(DictionaryEntry word) async {
    // Business logic validation
    if (word.word == null || word.word!.isEmpty) {
      return Left(InputNoImageFailure(errorMessage: 'Kelime boş olamaz'));
    }

    if (word.meanings == null || word.meanings!.isEmpty) {
      return Left(InputNoImageFailure(errorMessage: 'En az bir anlam eklenmelidir'));
    }

    // Validate meanings
    for (final meaning in word.meanings!) {
      if (meaning.partOfSpeech.isEmpty) {
        return Left(InputNoImageFailure(errorMessage: 'Kelime türü boş olamaz'));
      }
      
      if (meaning.definitions.isEmpty) {
        return Left(InputNoImageFailure(errorMessage: 'Her anlam için en az bir tanım gereklidir'));
      }
      
      for (final definition in meaning.definitions) {
        if (definition.definition.isEmpty) {
          return Left(InputNoImageFailure(errorMessage: 'Tanım boş olamaz'));
        }
      }
    }

    // Add metadata
    final wordWithMetadata = word.copyWith(
      createdAt: DateTime.now(),
    );

    return await repository.addWord(wordWithMetadata);
  }
} 