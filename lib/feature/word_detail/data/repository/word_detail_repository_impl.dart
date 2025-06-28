import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_local_data_source.dart';

class WordDetailRepositoryImpl {
  final WordDetailRemoteDataSource _remoteDataSource;
  final WordDetailLocalDataSource _localDataSource;

  WordDetailRepositoryImpl({
    required WordDetailRemoteDataSource remoteDataSource,
    required WordDetailLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  /// API'den kelime detaylarını getir
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromApi(String word) async {
    try {
      final result = await _remoteDataSource.getWordDetail(word);
      return result.fold(
        (failure) => Left(failure),
        (entries) => Right(entries.isNotEmpty ? entries.first : null),
      );
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  /// Firestore'dan kelime detaylarını getir
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromLocal(String word) async {
    try {
      return await _remoteDataSource.getWordDetailFromFirestore(word);
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  /// Kelimeyi Firestore'a kaydet
  Future<Either<Failure, String>> saveWordToLocal(DictionaryEntry entry) async {
    try {
      return await _remoteDataSource.saveWordToFirestore(entry);
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  /// Kelime Firestore'da var mı kontrol et
  Future<Either<Failure, bool>> isWordSaved(String word, String userId) async {
    try {
      return await _remoteDataSource.isWordSavedInFirestore(word, userId);
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }
} 