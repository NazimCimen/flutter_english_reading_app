import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';

class GetWordDetailFromApiUseCase {
  final WordDetailRepository _repository;

  GetWordDetailFromApiUseCase(this._repository);

  Future<Either<Failure, DictionaryEntry?>> call(String word) async {
    if (word.trim().isEmpty) {
      return Left(UnKnownFaliure(errorMessage: 'Word cannot be empty'));
    }
    
    return await _repository.getWordDetailFromApi(word);
  }
} 