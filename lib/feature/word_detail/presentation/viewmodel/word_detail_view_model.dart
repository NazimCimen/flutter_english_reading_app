import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';
import 'package:english_reading_app/services/user_service.dart';

enum WordDetailSource {
  api, 
  local, 
}

class WordDetailViewModel extends ChangeNotifier {
  final WordDetailRepositoryImpl _repository;
  final UserService _userService;
  final INetworkInfo _networkInfo;
  final Uuid _uuid = const Uuid();

  WordDetailViewModel(this._repository, this._userService, this._networkInfo);

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

    // Check internet connection
    final isConnected = await _networkInfo.currentConnectivityResult;
    
    if (!isConnected && source == WordDetailSource.api) {
      _setError('No internet connection. Please check your connection.');
      _setLoading(false);
      return;
    }

    // Check if word is already saved
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
        _setError(failure.errorMessage);
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
    final userId = _userService.getUserId();
    if (userId == null) {
      _isSaved = false;
      notifyListeners();
      return;
    }

    final result = await _repository.isWordSaved(word, userId);
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
    final userId = _userService.getUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return;
    }

    // Check internet connection
    final isConnected = await _networkInfo.currentConnectivityResult;
    
    if (!isConnected) {
      _setError('No internet connection. Word could not be saved.');
      return;
    }

    if (_wordDetail != null) {
      await _saveFullDictionaryEntry(_wordDetail!);
    } else {
      await _saveBasicWord(word);
    }
  }

  Future<void> _saveBasicWord(String word) async {
    final userId = _userService.getUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return;
    }
    
    final documentId = _uuid.v4(); 
    
    final basicEntry = DictionaryEntry(
      documentId: documentId,
      word: word,
      meanings: [],
      phonetics: [],
      userId: userId,
      createdAt: DateTime.now(),
    );

    final result = await _repository.saveWordToLocal(basicEntry);
    result.fold(
      (failure) {
        _setError(failure.errorMessage);
      },
      (docId) {
        _isSaved = true;
        notifyListeners();
      },
    );
  }

  Future<void> _saveFullDictionaryEntry(DictionaryEntry entry) async {
    final userId = _userService.getUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return;
    }

    final documentId = _uuid.v4();

    final entryWithUserId = entry.copyWith(
      documentId: documentId,
      userId: userId,
      createdAt: DateTime.now(),
    );

    final result = await _repository.saveWordToLocal(entryWithUserId);
    result.fold(
      (failure) {
        _setError(failure.errorMessage);
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
