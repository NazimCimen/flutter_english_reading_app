import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';

abstract class WordDetailLocalDataSource {
  Future<Either<Failure, DictionaryEntry?>> getWordDetail(String word);
  Future<Either<Failure, String>> saveWord(DictionaryEntry entry);
  Future<Either<Failure, bool>> isWordSaved(String word);
}

class WordDetailLocalDataSourceImpl implements WordDetailLocalDataSource {
  final BaseFirebaseService<DictionaryEntry> _firebaseService;

  WordDetailLocalDataSourceImpl(this._firebaseService);

  @override
  Future<Either<Failure, DictionaryEntry?>> getWordDetail(String word) async {
    try {
      // Firestore'dan kelimeyi getir
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
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveWord(DictionaryEntry entry) async {
    try {
      final docId = await _firebaseService.addItem(
        FirebaseCollectionEnum.dictionary.name,
        entry,
      );
      return Right(docId);
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isWordSaved(String word) async {
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
      return Right(result.isNotEmpty);
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }
} 