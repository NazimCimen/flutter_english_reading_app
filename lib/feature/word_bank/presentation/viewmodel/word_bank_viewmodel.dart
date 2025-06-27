import 'package:english_reading_app/feature/word_bank/data/repository/word_bank_repository_impl.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';

enum WordViewMode { list, card }

class WordBankViewmodel extends ChangeNotifier {
  final WordBankRepository _repository;
  
  List<DictionaryEntry> _words = [];
  bool _isLoading = false;
  WordViewMode _viewMode = WordViewMode.list;
  
  WordBankViewmodel(this._repository) {
    _initializeWords();
  }
  
  List<DictionaryEntry> get words => _words;
  bool get isLoading => _isLoading;
  WordViewMode get viewMode => _viewMode;
  
  void _initializeWords() {
    fetchWords();
  }
  
  Future<void> fetchWords() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _repository.getWords();
      result.fold(
        (failure) {
          // Error handling
        },
        (words) {
          _words = words;
        },
      );
    } catch (e) {
      // Error handling
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> refreshWords() async {
    await fetchWords();
  }
  
  Future<void> deleteWord(String documentId) async {
    try {
      final result = await _repository.deleteWord(documentId);
      result.fold(
        (failure) {
          // Error handling
        },
        (_) {
          _words.removeWhere((word) => word.documentId == documentId);
          notifyListeners();
        },
      );
    } catch (e) {
      // Error handling
    }
  }
  
  Future<void> updateWord(DictionaryEntry word) async {
    try {
      final result = await _repository.updateWord(word);
      result.fold(
        (failure) {
          // Error handling
        },
        (_) {
          final index = _words.indexWhere((w) => w.documentId == word.documentId);
          if (index != -1) {
            _words[index] = word;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      // Error handling
    }
  }
  
  Future<void> addWord(DictionaryEntry word) async {
    try {
      final result = await _repository.addWord(word);
      result.fold(
        (failure) {
          // Error handling
        },
        (docId) {
          final wordWithId = word.copyWith(documentId: docId);
          _words.add(wordWithId);
          notifyListeners();
        },
      );
    } catch (e) {
      // Error handling
    }
  }
  
  void addWordToLocalList(DictionaryEntry word) {
    _words.add(word);
    notifyListeners();
  }
  
  void toggleViewMode() {
    _viewMode = _viewMode == WordViewMode.list 
        ? WordViewMode.card 
        : WordViewMode.list;
    notifyListeners();
  }
} 