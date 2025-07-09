import 'package:english_reading_app/feature/word_bank/domain/usecase/get_words_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/search_words_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/add_word_to_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/update_word_in_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/delete_word_from_bank_usecase.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';

class WordBankViewModel extends ChangeNotifier {
  final GetWordsUseCase getWordsUseCase;
  final SearchWordsUseCase searchWordsUseCase;
  final AddWordToBankUseCase addWordToBankUseCase;
  final UpdateWordInBankUseCase updateWordInBankUseCase;
  final DeleteWordFromBankUseCase deleteWordFromBankUseCase;

  WordBankViewModel({
    required this.getWordsUseCase,
    required this.searchWordsUseCase,
    required this.addWordToBankUseCase,
    required this.updateWordInBankUseCase,
    required this.deleteWordFromBankUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  
  List<DictionaryEntry> _fetchedWords = [];
  List<DictionaryEntry> get fetchedWords => _fetchedWords;
  
  List<DictionaryEntry>? _searchedWords = [];
  List<DictionaryEntry>? get searchedWords => _searchedWords;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsSearch(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  Future<void> fetchWords({int limit = 10, bool reset = false}) async {
    _setLoading(true);
    
    final result = await getWordsUseCase(limit: limit, reset: reset);
    
    result.fold(
      (failure) {
        // Error handling - could be logged or shown to user
        print('Error fetching words: ${failure.errorMessage}');
      },
      (words) {
        _fetchedWords = words;
      },
    );
    
    _setLoading(false);
  }

  Future<void> searchWords(String query) async {
    setIsSearch(true);
    
    final result = await searchWordsUseCase(query);
    
    result.fold(
      (failure) {
        // Error handling - could be logged or shown to user
        print('Error searching words: ${failure.errorMessage}');
        _searchedWords = null;
      },
      (words) {
        _searchedWords = words;
      },
    );
    
    setIsSearch(false);
  }

  Future<bool> addWord(DictionaryEntry word) async {
    _setLoading(true);
    
    final result = await addWordToBankUseCase(word);
    
    bool success = false;
    result.fold(
      (failure) {
        // Error handling - could be logged or shown to user
        print('Error adding word: ${failure.errorMessage}');
        success = false;
      },
      (documentId) {
        // Success - could refresh the word list
        print('Word added successfully with ID: $documentId');
        success = true;
      },
    );
    
    _setLoading(false);
    return success;
  }

  Future<bool> updateWord(DictionaryEntry word) async {
    _setLoading(true);
    
    final result = await updateWordInBankUseCase(word);
    
    bool success = false;
    result.fold(
      (failure) {
        // Error handling - could be logged or shown to user
        print('Error updating word: ${failure.errorMessage}');
        success = false;
      },
      (_) {
        // Success - could refresh the word list
        print('Word updated successfully');
        success = true;
      },
    );
    
    _setLoading(false);
    return success;
  }

  Future<bool> deleteWord(String documentId) async {
    _setLoading(true);
    
    final result = await deleteWordFromBankUseCase(documentId);
    
    bool success = false;
    result.fold(
      (failure) {
        // Error handling - could be logged or shown to user
        print('Error deleting word: ${failure.errorMessage}');
        success = false;
      },
      (_) {
        // Success - could refresh the word list
        print('Word deleted successfully');
        success = true;
      },
    );
    
    _setLoading(false);
    return success;
  }
}
