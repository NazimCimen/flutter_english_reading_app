import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';

class SaveWordToLocalUseCase {
  final WordDetailRepository _repository;

  SaveWordToLocalUseCase(this._repository);

  Future<Either<Failure, String>> call(DictionaryEntry entry) async {
    if (entry.word?.trim().isEmpty ?? true) {
      return Left(UnKnownFaliure(errorMessage: 'Word cannot be empty'));
    }
    
    if (entry.meanings?.isEmpty ?? true) {
      return Left(UnKnownFaliure(errorMessage: 'Word must have at least one meaning'));
    }
    
    return await _repository.saveWordToLocal(entry);
  }
} 