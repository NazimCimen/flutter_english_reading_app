import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';

/// Use case for checking if a word is saved by the user
class IsWordSavedUseCase {
  final WordDetailRepository _repository;

  IsWordSavedUseCase(this._repository);

  /// Executes the use case to check if word is saved with validation
  Future<Either<Failure, bool>> call(String word, String userId) async {
    if (word.trim().isEmpty) {
      return Left(UnKnownFaliure(errorMessage: StringConstants.wordCannotBeEmpty));
    }
    
    if (userId.trim().isEmpty) {
      return Left(UnKnownFaliure(errorMessage: StringConstants.userIdCannotBeEmpty));
    }
    
    return _repository.isWordSaved(word, userId);
  }
} 