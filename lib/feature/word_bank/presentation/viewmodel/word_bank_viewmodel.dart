import 'package:english_reading_app/feature/word_bank/data/repository/word_bank_repository.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';

class WordBankViewModel extends ChangeNotifier {
  final WordBankRepository _repository;
  WordBankViewModel(this._repository);
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  List<DictionaryEntry> _fetchedWords = [];
  List<DictionaryEntry> get fetchedWords => _fetchedWords;
  List<DictionaryEntry> _searchedWords = [];
  List<DictionaryEntry> get searchedWords => _searchedWords;

  /// search - saved word
  /// saved word clean

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchWords({int limit = 10, bool reset = false}) async {
    final result = await _repository.getWords(limit: limit, reset: reset);
    result.fold((failure) {}, (words) {
      _fetchedWords = words;
    });
  }

  void setIsSearch(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  Future<void> searchWords(String query) async {
    _searchedWords = [DictionaryEntry(word: 'sffds')];
  }

  /*
  Future<void> deleteWord(String documentId) async {
    final result = await _repository.deleteWord(documentId);
    result.fold(
      (failure) {
        // Error handling - UI'da gösterilecek
      },
      (_) {
        _allWords.removeWhere((word) => word.documentId == documentId);
        final currentItems = List<DictionaryEntry>.from(
          pagingController.itemList ?? [],
        );
        currentItems.removeWhere((word) => word.documentId == documentId);
        pagingController.itemList = currentItems;
        notifyListeners();
      },
    );
  }

  Future<void> updateWord(DictionaryEntry word) async {
    final result = await _repository.updateWord(word);
    result.fold(
      (failure) {
        // Error handling - UI'da gösterilecek
      },
      (_) {
        final allIndex = _allWords.indexWhere(
          (w) => w.documentId == word.documentId,
        );
        if (allIndex != -1) {
          _allWords[allIndex] = word;
        }

        final currentItems = List<DictionaryEntry>.from(
          pagingController.itemList ?? [],
        );
        final index = currentItems.indexWhere(
          (w) => w.documentId == word.documentId,
        );
        if (index != -1) {
          currentItems[index] = word;
          pagingController.itemList = currentItems;
        }

        notifyListeners();
      },
    );
  }

  Future<void> addWord(DictionaryEntry word) async {
    final result = await _repository.addWord(word);
    result.fold(
      (failure) {
        // Error handling - UI'da gösterilecek
      },
      (docId) {
        final wordWithId = word.copyWith(documentId: docId);
        _allWords.insert(0, wordWithId); // En başa ekle

        // Eğer arama aktifse ve kelime arama kriterlerine uyuyorsa
        if (_currentSearchQuery.isEmpty ||
            word.word.toLowerCase().contains(_currentSearchQuery) ||
            word.meanings.any(
              (meaning) => meaning.definitions.any(
                (def) =>
                    def.definition.toLowerCase().contains(_currentSearchQuery),
              ),
            )) {
          final currentItems = List<DictionaryEntry>.from(
            pagingController.itemList ?? [],
          );
          currentItems.insert(0, wordWithId);
          pagingController.itemList = currentItems;
        }

        notifyListeners();
      },
    );
  }

  void addWordToLocalList(DictionaryEntry word) {
    _allWords.insert(0, word);
    final currentItems = List<DictionaryEntry>.from(
      pagingController.itemList ?? [],
    );
    currentItems.insert(0, word);
    pagingController.itemList = currentItems;
    notifyListeners();
  }

  /// Reset WordBankViewModel when user logs out
  void reset() {
    _allWords.clear();
    _isLoading = false;
    _currentSearchQuery = '';
    pagingController.itemList = [];
    pagingController.nextPageKey = 0;
    notifyListeners();
  }
*/
}
