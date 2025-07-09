import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_api_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_local_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/save_word_to_local_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/is_word_saved_usecase.dart';
import 'package:english_reading_app/product/services/user_service.dart';

enum WordDetailSource { api, local }

class WordDetailViewModel extends ChangeNotifier {
  final GetWordDetailFromApiUseCase _getWordDetailFromApiUseCase;
  final GetWordDetailFromLocalUseCase _getWordDetailFromLocalUseCase;
  final SaveWordToLocalUseCase _saveWordToLocalUseCase;
  final IsWordSavedUseCase _isWordSavedUseCase;
  final UserService _userService;
  final Uuid _uuid = const Uuid();

  WordDetailViewModel({
    required GetWordDetailFromApiUseCase getWordDetailFromApiUseCase,
    required GetWordDetailFromLocalUseCase getWordDetailFromLocalUseCase,
    required SaveWordToLocalUseCase saveWordToLocalUseCase,
    required IsWordSavedUseCase isWordSavedUseCase,
    required UserService userService,
  })  : _getWordDetailFromApiUseCase = getWordDetailFromApiUseCase,
        _getWordDetailFromLocalUseCase = getWordDetailFromLocalUseCase,
        _saveWordToLocalUseCase = saveWordToLocalUseCase,
        _isWordSavedUseCase = isWordSavedUseCase,
        _userService = userService;

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

    // Check if word is already saved
    await _checkIfWordIsSaved(word);

    Either<Failure, DictionaryEntry?> result;

    switch (source) {
      case WordDetailSource.api:
        result = await _getWordDetailFromApiUseCase(word);
        break;
      case WordDetailSource.local:
        result = await _getWordDetailFromLocalUseCase(word);
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

    final result = await _isWordSavedUseCase(word, userId);
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

    final result = await _saveWordToLocalUseCase(basicEntry);
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
      meanings:
          entry.meanings != null
              ? entry.meanings!
                  .map((meaning) => meaning.copyWith(id: _uuid.v4()))
                  .toList()
              : [],
    );

    final result = await _saveWordToLocalUseCase(entryWithUserId);
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
