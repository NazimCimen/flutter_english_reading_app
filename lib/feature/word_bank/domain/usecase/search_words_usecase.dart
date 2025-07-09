import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';

class SearchWordsUseCase {
  final WordBankRepository repository;

  SearchWordsUseCase({required this.repository});

  Future<Either<Failure, List<DictionaryEntry>?>> call(String query) async {
    // Business logic validation
    final trimmedQuery = query.trim();
    
    if (trimmedQuery.isEmpty) {
      return Left(InputNoImageFailure(errorMessage: 'Arama sorgusu boş olamaz'));
    }

    if (trimmedQuery.length < 2) {
      return Left(InputNoImageFailure(errorMessage: 'Arama sorgusu en az 2 karakter olmalıdır'));
    }

    if (trimmedQuery.length > 50) {
      return Left(InputNoImageFailure(errorMessage: 'Arama sorgusu 50 karakterden uzun olamaz'));
    }

    return await repository.searchWord(query: trimmedQuery);
  }
} 