import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';

class GetWordsUseCase {
  final WordBankRepository repository;

  GetWordsUseCase({required this.repository});

  Future<Either<Failure, List<DictionaryEntry>>> call({
    int limit = 10,
    bool reset = false,
  }) async {
    // Business logic validation
    if (limit <= 0) {
      return Left(InputNoImageFailure(errorMessage: 'Limit pozitif bir sayı olmalıdır'));
    }

    if (limit > 100) {
      return Left(InputNoImageFailure(errorMessage: 'Limit 100\'den büyük olamaz'));
    }

    return await repository.getWords(limit: limit, reset: reset);
  }
} 