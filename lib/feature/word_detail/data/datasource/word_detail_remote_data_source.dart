import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/services/dictionary_service.dart';

abstract class WordDetailRemoteDataSource {
  Future<Either<Failure, List<DictionaryEntry>>> getWordDetail(String word);
}

class WordDetailRemoteDataSourceImpl implements WordDetailRemoteDataSource {
  final DictionaryService _dictionaryService;

  WordDetailRemoteDataSourceImpl(this._dictionaryService);

  @override
  Future<Either<Failure, List<DictionaryEntry>>> getWordDetail(String word) async {
    try {
      final result = await _dictionaryService.getWordDetail(word);
      return result;
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }
} 