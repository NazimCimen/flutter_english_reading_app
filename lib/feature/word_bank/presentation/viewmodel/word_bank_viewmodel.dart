import 'package:english_reading_app/feature/word_bank/data/repository/word_bank_repository_impl.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WordBankViewmodel extends ChangeNotifier {
  final WordBankRepository _repository;
  
  static const _pageSize = 20;
  
  final PagingController<int, DictionaryEntry> pagingController = 
      PagingController(firstPageKey: 0);
  
  List<DictionaryEntry> _allWords = [];
  bool _isLoading = false;
  String _currentSearchQuery = '';
  
  WordBankViewmodel(this._repository) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _initializeWords();
  }
  
  List<DictionaryEntry> get words => pagingController.itemList ?? [];
  List<DictionaryEntry> get allWords => _allWords;
  bool get isLoading => _isLoading;
  String get currentSearchQuery => _currentSearchQuery;
  
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
          _allWords = words;
          _loadFirstPage();
        },
      );
    } catch (e) {
      // Error handling
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void _loadFirstPage() {
    final firstPageWords = _allWords.take(_pageSize).toList();
    pagingController.itemList = firstPageWords;
    
    // Eğer daha fazla sayfa varsa, sadece itemList'i güncelle
    if (_allWords.length > _pageSize) {
      // Sayfalama için hazırlık yap ama duplicate ekleme
      pagingController.nextPageKey = 1;
    } else {
      pagingController.nextPageKey = null;
    }
  }
  
  Future<void> _fetchPage(int pageKey) async {
    try {
      final startIndex = pageKey * _pageSize;
      final endIndex = startIndex + _pageSize;
      
      if (startIndex >= _allWords.length) {
        pagingController.appendLastPage([]);
        return;
      }
      
      final newWords = _allWords.sublist(
        startIndex, 
        endIndex > _allWords.length ? _allWords.length : endIndex,
      );
      
      final isLastPage = endIndex >= _allWords.length;
      if (isLastPage) {
        pagingController.appendLastPage(newWords);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newWords, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
  
  void searchWords(String query) {
    _currentSearchQuery = query.toLowerCase().trim();
    
    if (_currentSearchQuery.isEmpty) {
      // Arama boşsa normal sayfalama
      _loadFirstPage();
    } else {
      // Arama varsa tüm kelimelerde filtrele
      final filteredWords = _allWords.where((word) {
        return word.word.toLowerCase().contains(_currentSearchQuery) ||
               word.meanings.any((meaning) =>
                 meaning.definitions.any((def) =>
                   def.definition.toLowerCase().contains(_currentSearchQuery)
                 )
               );
      }).toList();
      
      // Sadece itemList'i set et, appendLastPage çağırma
      pagingController.itemList = filteredWords;
    }
    
    notifyListeners();
  }
  
  void clearSearch() {
    _currentSearchQuery = '';
    _loadFirstPage();
    notifyListeners();
  }
  
  Future<void> refreshWords() async {
    pagingController.refresh();
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
          _allWords.removeWhere((word) => word.documentId == documentId);
          final currentItems = List<DictionaryEntry>.from(pagingController.itemList ?? []);
          currentItems.removeWhere((word) => word.documentId == documentId);
          pagingController.itemList = currentItems;
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
          final allIndex = _allWords.indexWhere((w) => w.documentId == word.documentId);
          if (allIndex != -1) {
            _allWords[allIndex] = word;
          }
          
          final currentItems = List<DictionaryEntry>.from(pagingController.itemList ?? []);
          final index = currentItems.indexWhere((w) => w.documentId == word.documentId);
          if (index != -1) {
            currentItems[index] = word;
            pagingController.itemList = currentItems;
          }
          
          notifyListeners();
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
          _allWords.insert(0, wordWithId); // En başa ekle
          
          // Eğer arama aktifse ve kelime arama kriterlerine uyuyorsa
          if (_currentSearchQuery.isEmpty || 
              word.word.toLowerCase().contains(_currentSearchQuery) ||
              word.meanings.any((meaning) =>
                meaning.definitions.any((def) =>
                  def.definition.toLowerCase().contains(_currentSearchQuery)
                )
              )) {
            final currentItems = List<DictionaryEntry>.from(pagingController.itemList ?? []);
            currentItems.insert(0, wordWithId);
            pagingController.itemList = currentItems;
          }
          
          notifyListeners();
        },
      );
    } catch (e) {
      // Error handling
    }
  }
  
  void addWordToLocalList(DictionaryEntry word) {
    _allWords.insert(0, word);
    final currentItems = List<DictionaryEntry>.from(pagingController.itemList ?? []);
    currentItems.insert(0, word);
    pagingController.itemList = currentItems;
    notifyListeners();
  }
  
  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
} 