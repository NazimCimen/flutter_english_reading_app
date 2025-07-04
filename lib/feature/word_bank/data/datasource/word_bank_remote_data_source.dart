import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

abstract class WordBankRemoteDataSource {
  Future<List<DictionaryEntry>> getWords({
    required String userId,
    int limit = 10,
    bool reset = false,
  });
  Future<Either<Failure, List<DictionaryEntry>?>> searchWord({
    required String query,
  });
  Future<String> addWord(DictionaryEntry word);
  Future<void> updateWord(DictionaryEntry word);
  Future<void> deleteWord(String documentId);
}

class WordBankRemoteDataSourceImpl implements WordBankRemoteDataSource {
  final BaseFirebaseService<DictionaryEntry> _firebaseService;
  final String _collectionPath = FirebaseCollectionEnum.dictionary.name;

  DocumentSnapshot? _lastDocument;
  DocumentSnapshot? get lastDocument => _lastDocument;

  WordBankRemoteDataSourceImpl({
    required BaseFirebaseService<DictionaryEntry> firebaseService,
  }) : _firebaseService = firebaseService;

  @override
  Future<List<DictionaryEntry>> getWords({
    required String userId,
    int limit = 10,
    bool reset = false,
  }) async {
    try {
      if (reset) _lastDocument = null;
      Query query = FirebaseFirestore.instance
          .collection(_collectionPath)
          .orderBy('createdAt', descending: true)
          .where('userId', isEqualTo: userId)
          .limit(limit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      }

      return querySnapshot.docs
          .map(
            (doc) =>
                DictionaryEntry().fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } on TimeoutException {
      throw ServerException('Request timeout');
    } catch (e) {
      throw ServerException('Failed to fetch words: ${e.toString()}');
    }
  }

  @override
  Future<String> addWord(DictionaryEntry word) async {
    try {
      final docId = await _firebaseService.addItem(
        FirebaseCollectionEnum.dictionary.name,
        word,
      );
      return docId;
    } on TimeoutException {
      throw ServerException('Request timeout');
    } catch (e) {
      throw ServerException('Failed to add word: ${e.toString()}');
    }
  }

  @override
  Future<void> updateWord(DictionaryEntry word) async {
    try {
      await _firebaseService.updateItem(
        FirebaseCollectionEnum.dictionary.name,
        word.documentId!,
        word,
      );
    } on TimeoutException {
      throw ServerException('Request timeout');
    } catch (e) {
      throw ServerException('Failed to update word: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteWord(String documentId) async {
    try {
      await _firebaseService.deleteItem(
        FirebaseCollectionEnum.dictionary.name,
        documentId,
      );
    } on TimeoutException {
      throw ServerException('Request timeout');
    } catch (e) {
      throw ServerException('Failed to delete word: ${e.toString()}');
    }
  }

  @override
  Future<Either<Failure, List<DictionaryEntry>?>> searchWord({
    required String query,
  }) async {
    try {
      if (query == '') return const Right([]);
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection(FirebaseCollectionEnum.dictionary.name)
              .where('word', isGreaterThanOrEqualTo: query)
              .where('word', isLessThanOrEqualTo: query + '\uf8ff')
              .orderBy('word')
              .get();

      return Right(
        querySnapshot.docs
            .map((doc) => DictionaryEntry().fromJson(doc.data()))
            .toList(),
      );
    } on TimeoutException {
      return Left(ServerFailure(errorMessage: 'Request timeout'));
    } catch (e) {
      return Left(
        ServerFailure(errorMessage: 'Failed to search word: ${e.toString()}'),
      );
    }
  }
}
