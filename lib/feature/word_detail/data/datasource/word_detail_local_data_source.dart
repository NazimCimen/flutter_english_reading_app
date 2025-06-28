import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

abstract class WordDetailLocalDataSource {
  Future<Either<Failure, DictionaryEntry?>> getWordDetail(String word);
  Future<Either<Failure, String>> saveWord(DictionaryEntry entry);
  Future<Either<Failure, bool>> isWordSaved(String word, String userId);
}

class WordDetailLocalDataSourceImpl implements WordDetailLocalDataSource {
  @override
  Future<Either<Failure, DictionaryEntry?>> getWordDetail(String word) async {
    // TODO: Implement local storage (Hive/SharedPreferences)
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> saveWord(DictionaryEntry entry) async {
    // TODO: Implement local storage (Hive/SharedPreferences)
    return Right('local_${DateTime.now().millisecondsSinceEpoch}');
  }

  @override
  Future<Either<Failure, bool>> isWordSaved(String word, String userId) async {
    // TODO: Implement local storage (Hive/SharedPreferences)
    return const Right(false);
  }
} 