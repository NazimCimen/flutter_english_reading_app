import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

abstract class WordDetailRepository {
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromApi(String word);
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromFirestore(String word);
  Future<Either<Failure, void>> saveWordToFirestore(DictionaryEntry entry);
  Future<Either<Failure, bool>> isWordSaved(String word, String userId);
} 