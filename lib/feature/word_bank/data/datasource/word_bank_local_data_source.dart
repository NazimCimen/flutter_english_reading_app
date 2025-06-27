import 'package:english_reading_app/product/model/dictionary_entry.dart';

abstract class WordBankLocalDataSource {
  Future<List<DictionaryEntry>> getWords();
  Future<void> addWord(DictionaryEntry word);
  Future<void> updateWord(DictionaryEntry word);
  Future<void> deleteWord(String documentId);
  Future<void> clearWords();
}

class WordBankLocalDataSourceImpl implements WordBankLocalDataSource {
  // TODO: Implement local storage (Hive, SharedPreferences, etc.)
  
  @override
  Future<List<DictionaryEntry>> getWords() async {
    // TODO: Implement local storage
    return [];
  }

  @override
  Future<void> addWord(DictionaryEntry word) async {
    // TODO: Implement local storage
  }

  @override
  Future<void> updateWord(DictionaryEntry word) async {
    // TODO: Implement local storage
  }

  @override
  Future<void> deleteWord(String documentId) async {
    // TODO: Implement local storage
  }

  @override
  Future<void> clearWords() async {
    // TODO: Implement local storage
  }
} 