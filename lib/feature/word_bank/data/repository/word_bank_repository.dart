import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

abstract class WordBankRepository {
  Future<Either<Failure, List<DictionaryEntry>>> getWords({
    required int limit,
    required bool reset,
  });
  Future<Either<Failure, String>> addWord(DictionaryEntry word);
  Future<Either<Failure, void>> updateWord(DictionaryEntry word);
  Future<Either<Failure, void>> deleteWord(String documentId);
}
