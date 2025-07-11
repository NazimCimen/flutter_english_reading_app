import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

abstract class AddWordRepository {
  Future<Either<Failure, DictionaryEntry>> saveWord(DictionaryEntry word);
}
