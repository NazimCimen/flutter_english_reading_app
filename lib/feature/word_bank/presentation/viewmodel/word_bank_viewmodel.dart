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
  List<DictionaryEntry>? _searchedWords = [];
  List<DictionaryEntry>? get searchedWords => _searchedWords;

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
    final response = await _repository.searchWord(query: query);
    response.fold((failure) {}, (result) {
      _searchedWords = result;
    });
  }


}
