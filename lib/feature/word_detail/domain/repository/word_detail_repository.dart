import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

/// Repository interface for word detail operations
abstract class WordDetailRepository {
  /// Fetches word details from external API
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromApi(String word);
  
  /// Retrieves word details from local storage
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromFirestore(String word);
  
  /// Saves word entry to local storage
  Future<Either<Failure, String>> saveWordToLocal(DictionaryEntry entry);
  
  /// Checks if word is saved by the user
  Future<Either<Failure, bool>> isWordSaved(String word, String userId);
} 