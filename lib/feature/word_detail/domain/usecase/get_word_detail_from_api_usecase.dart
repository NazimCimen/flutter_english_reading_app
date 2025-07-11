import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';

/// Use case for fetching word details from external API
class GetWordDetailFromApiUseCase {
  final WordDetailRepository _repository;

  GetWordDetailFromApiUseCase(this._repository);

  /// Executes the use case to get word details from API with validation
  Future<Either<Failure, DictionaryEntry?>> call(String word) async {
    if (word.trim().isEmpty) {
      return Left(UnKnownFaliure(errorMessage: StringConstants.wordCannotBeEmpty));
    }
    
    return _repository.getWordDetailFromApi(word);
  }
} 