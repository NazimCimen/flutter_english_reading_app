import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';

abstract class WordDetailRemoteDataSource {
  Future<Either<Failure, List<DictionaryEntry>>> getWordDetail(String word);
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromFirestore(String word);
  Future<Either<Failure, String>> saveWordToFirestore(DictionaryEntry entry);
  Future<Either<Failure, bool>> isWordSavedInFirestore(String word, String userId);
}

class WordDetailRemoteDataSourceImpl implements WordDetailRemoteDataSource {
  final Dio _dio;
  final BaseFirebaseService<DictionaryEntry> _firebaseService;

  WordDetailRemoteDataSourceImpl(this._dio, this._firebaseService);

  @override
  Future<Either<Failure, List<DictionaryEntry>>> getWordDetail(String word) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );

      if (response.statusCode == 200) {
        final data = (response.data as List)
            .cast<Map<String, dynamic>>()
            .map((json) => DictionaryEntry.fromJson(json))
            .toList();
        return Right(data);
      } else {
        return Left(ServerFailure(errorMessage: 'Sunucu hatası: ${response.statusCode}'));
      }
    } on TimeoutException {
      return Left(ServerFailure(errorMessage: 'İstek zaman aşımına uğradı'));
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: 'İstek hatası: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'Bilinmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromFirestore(String word) async {
    try {
      final result = await _firebaseService.queryItems(
        collectionPath: FirebaseCollectionEnum.dictionary.name,
        conditions: {'word': word},
        model: DictionaryEntry(
          word: word,
          meanings: [],
          phonetics: [],
        ),
      );
      
      if (result.isNotEmpty) {
        return Right(result.first);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveWordToFirestore(DictionaryEntry entry) async {
    try {
      final docId = await _firebaseService.addItem(
        FirebaseCollectionEnum.dictionary.name,
        entry,
      );
      return Right(docId);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isWordSavedInFirestore(String word, String userId) async {
    try {
      final result = await _firebaseService.queryItems(
        collectionPath: FirebaseCollectionEnum.dictionary.name,
        conditions: {'word': word, 'userId': userId},
        model: DictionaryEntry(
          word: word,
          meanings: [],
          phonetics: [],
        ),
      );
      return Right(result.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
} 