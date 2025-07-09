import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';

class IsWordSavedUseCase {
  final WordDetailRepository _repository;

  IsWordSavedUseCase(this._repository);

  Future<Either<Failure, bool>> call(String word, String userId) async {
    if (word.trim().isEmpty) {
      return Left(UnKnownFaliure(errorMessage: 'Word cannot be empty'));
    }
    
    if (userId.trim().isEmpty) {
      return Left(UnKnownFaliure(errorMessage: 'User ID cannot be empty'));
    }
    
    return await _repository.isWordSaved(word, userId);
  }
} 