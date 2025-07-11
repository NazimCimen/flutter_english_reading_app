import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';

/// Use case for saving word entry to local storage
class SaveWordToLocalUseCase {
  final WordDetailRepository _repository;

  SaveWordToLocalUseCase(this._repository);

  /// Executes the use case to save word to local storage with validation
  Future<Either<Failure, String>> call(DictionaryEntry entry) async {
    if (entry.word?.trim().isEmpty ?? true) {
      return Left(UnKnownFaliure(errorMessage: StringConstants.wordCannotBeEmpty));
    }
    
    if (entry.meanings?.isEmpty ?? true) {
      return Left(UnKnownFaliure(errorMessage: StringConstants.wordMustHaveAtLeastOneMeaning));
    }
    
    return _repository.saveWordToLocal(entry);
  }
} 