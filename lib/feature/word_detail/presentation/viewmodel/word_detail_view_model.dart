import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';

enum WordDetailSource {
  api,    // Article detail'den geliyor
  local,  // Word bank'tan geliyor
}

class WordDetailViewModel extends ChangeNotifier {
  final WordDetailRepositoryImpl _repository;
  
  WordDetailViewModel(this._repository);
  
  DictionaryEntry? _wordDetail;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSaved = false;
  
  DictionaryEntry? get wordDetail => _wordDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSaved => _isSaved;
  
  Future<void> loadWordDetail({
    required String word,
    required WordDetailSource source,
  }) async {
    _setLoading(true);
    _clearError();
    
    // Kelimenin zaten kaydedilip kaydedilmediğini kontrol et
    await _checkIfWordIsSaved(word);
    
    Either<Failure, DictionaryEntry?> result;
    
    switch (source) {
      case WordDetailSource.api:
        result = await _repository.getWordDetailFromApi(word);
        break;
      case WordDetailSource.local:
        result = await _repository.getWordDetailFromLocal(word);
        break;
    }
    
    result.fold(
      (failure) {
        _setError(failure.errorMessage ?? 'Kelime detayları yüklenemedi');
        _setLoading(false);
      },
      (entry) {
        _wordDetail = entry;
        _setLoading(false);
        notifyListeners();
      },
    );
  }
  
  Future<void> _checkIfWordIsSaved(String word) async {
    final result = await _repository.isWordSaved(word);
    result.fold(
      (failure) {
        _isSaved = false;
      },
      (isSaved) {
        _isSaved = isSaved;
      },
    );
    notifyListeners();
  }
  
  Future<void> saveWord(String word) async {
    // Önce API'den kelime detaylarını al
    final apiResult = await _repository.getWordDetailFromApi(word);
    
    apiResult.fold(
      (failure) {
        // API'den veri alınamadıysa sadece kelimeyi kaydet
        _saveBasicWord(word);
      },
      (entry) {
        if (entry != null) {
          // Tam DictionaryEntry'yi kaydet
          _saveFullDictionaryEntry(entry);
        } else {
          // Sadece kelimeyi kaydet
          _saveBasicWord(word);
        }
      },
    );
  }
  
  Future<void> _saveBasicWord(String word) async {
    final basicEntry = DictionaryEntry(
      documentId: null,
      word: word,
      meanings: [],
      phonetics: [],
      userId: 'current_user_id', // TODO: Get from auth service
      createdAt: DateTime.now(),
    );
    
    final result = await _repository.saveWordToLocal(basicEntry);
    result.fold(
      (failure) {
        _setError(failure.errorMessage ?? 'Kelime kaydedilemedi');
      },
      (docId) {
        _isSaved = true;
        notifyListeners();
      },
    );
  }
  
  Future<void> _saveFullDictionaryEntry(DictionaryEntry entry) async {
    final entryWithUserId = entry.copyWith(
      documentId: null,
      userId: 'current_user_id', // TODO: Get from auth service
      createdAt: DateTime.now(),
    );
    
    final result = await _repository.saveWordToLocal(entryWithUserId);
    result.fold(
      (failure) {
        _setError(failure.errorMessage ?? 'Kelime kaydedilemedi');
      },
      (docId) {
        _isSaved = true;
        notifyListeners();
      },
    );
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
} 