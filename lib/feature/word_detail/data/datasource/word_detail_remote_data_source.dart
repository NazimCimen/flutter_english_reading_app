import 'dart:async';
import 'package:dio/dio.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';

abstract class WordDetailRemoteDataSource {
  Future<List<DictionaryEntry>> getWordDetail(String word);
  Future<DictionaryEntry?> getWordDetailFromFirestore(String word);
  Future<String> saveWordToFirestore(DictionaryEntry entry);
  Future<bool> isWordSavedInFirestore(String word, String userId);
}

class WordDetailRemoteDataSourceImpl implements WordDetailRemoteDataSource {
  final Dio _dio;
  final BaseFirebaseService<DictionaryEntry> _firebaseService;

  WordDetailRemoteDataSourceImpl(this._dio, this._firebaseService);

  @override
  Future<List<DictionaryEntry>> getWordDetail(String word) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );

      if (response.statusCode == 200) {
        final data = (response.data as List)
            .cast<Map<String, dynamic>>()
            .map((json) => DictionaryEntry.fromJson(json))
            .toList();
        return data;
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ServerException('Request timeout');
    } on DioException catch (e) {
      throw ServerException('Request error: ${e.message}');
    } catch (e) {
      throw UnKnownException('Unknown error: $e');
    }
  }

  @override
  Future<DictionaryEntry?> getWordDetailFromFirestore(String word) async {
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
        return result.first;
      }
      return null;
    } catch (e) {
      throw ServerException('Firestore error: $e');
    }
  }

  @override
  Future<String> saveWordToFirestore(DictionaryEntry entry) async {
    try {
      final docId = await _firebaseService.addItem(
        FirebaseCollectionEnum.dictionary.name,
        entry,
      );
      return docId;
    } catch (e) {
      throw ServerException('Firestore error: $e');
    }
  }

  @override
  Future<bool> isWordSavedInFirestore(String word, String userId) async {
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
      return result.isNotEmpty;
    } catch (e) {
      throw ServerException('Firestore error: $e');
    }
  }
} 