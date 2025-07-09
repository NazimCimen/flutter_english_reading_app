import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';

abstract class AddWordRemoteDataSource {
  Future<DictionaryEntry> saveWord(DictionaryEntry word);
  Future<bool> updateWord(DictionaryEntry word);
  Future<bool> deleteWord(String wordId);
  Future<List<DictionaryEntry>> getUserWords(String userId);
}

class AddWordRemoteDataSourceImpl implements AddWordRemoteDataSource {
  final BaseFirebaseService firebaseService;

  AddWordRemoteDataSourceImpl(this.firebaseService);

  @override
  Future<DictionaryEntry> saveWord(DictionaryEntry word) async {
    try {
      final docId = await firebaseService.addItem('user_words', word);
      return word.copyWith(documentId: docId);
    } on FormatException catch (e) {
      throw ServerException('Veri formatı hatası: ${e.message}');
    } catch (e) {
      throw ServerException('Kelime kaydetme işlemi başarısız: ${e.toString()}');
    }
  }

  @override
  Future<bool> updateWord(DictionaryEntry word) async {
    try {
      await firebaseService.updateItem(
        'user_words',
        word.documentId!,
        word,
      );
      return true;
    } on FormatException catch (e) {
      throw ServerException('Veri formatı hatası: ${e.message}');
    } catch (e) {
      throw ServerException('Kelime güncelleme işlemi başarısız: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteWord(String wordId) async {
    try {
      await firebaseService.deleteItem('user_words', wordId);
      return true;
    } catch (e) {
      throw ServerException('Kelime silme işlemi başarısız: ${e.toString()}');
    }
  }

  @override
  Future<List<DictionaryEntry>> getUserWords(String userId) async {
    try {
      final words = await firebaseService.queryItems(
        collectionPath: 'user_words',
        conditions: {'userId': userId},
        model: DictionaryEntry.fromJson({}),
      );
      return words.cast<DictionaryEntry>();
    } on FormatException catch (e) {
      throw ServerException('Veri formatı hatası: ${e.message}');
    } catch (e) {
      throw ServerException('Kelimeler yüklenirken hata: ${e.toString()}');
    }
  }
} 