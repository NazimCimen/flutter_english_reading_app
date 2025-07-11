import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_api_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_firestore_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/save_word_to_local_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/is_word_saved_usecase.dart';
import 'package:english_reading_app/product/services/user_service.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';

/// Enum to specify the source of word detail data
enum WordDetailSource { api, firestore }

/// ViewModel for managing word detail state and operations
class WordDetailViewModel extends ChangeNotifier {
  final GetWordDetailFromApiUseCase _getWordDetailFromApiUseCase;
  final GetWordDetailFromFirestoreUseCase _getWordDetailFromLocalUseCase;
  final SaveWordToLocalUseCase _saveWordToLocalUseCase;
  final IsWordSavedUseCase _isWordSavedUseCase;
  final UserService _userService;
  final Uuid _uuid = const Uuid();

  WordDetailViewModel({
    required GetWordDetailFromApiUseCase getWordDetailFromApiUseCase,
    required GetWordDetailFromFirestoreUseCase getWordDetailFromLocalUseCase,
    required SaveWordToLocalUseCase saveWordToLocalUseCase,
    required IsWordSavedUseCase isWordSavedUseCase,
    required UserService userService,
  }) : _getWordDetailFromApiUseCase = getWordDetailFromApiUseCase,
       _getWordDetailFromLocalUseCase = getWordDetailFromLocalUseCase,
       _saveWordToLocalUseCase = saveWordToLocalUseCase,
       _isWordSavedUseCase = isWordSavedUseCase,
       _userService = userService;

  DictionaryEntry? _wordDetail;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSaved = false;

  /// Current word detail data
  DictionaryEntry? get wordDetail => _wordDetail;

  /// Loading state indicator
  bool get isLoading => _isLoading;

  /// Current error message if any
  String? get errorMessage => _errorMessage;

  /// Whether the word is saved by the user
  bool get isSaved => _isSaved;

  /// Loads word detail from the specified source (API or local storage)
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
      case WordDetailSource.firestore:
        result = await _getWordDetailFromLocalUseCase(word);
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

  /// Checks if the word is already saved by the current user
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

  /// Saves a word to the user's personal dictionary
  Future<void> saveWord(String word) async {
    final userId = _userService.getUserId();
    if (userId == null) {
      _setError(StringConstants.userNotAuthenticated);
      return;
    }

    if (_wordDetail != null) {
      await _saveFullDictionaryEntry(_wordDetail!);
    } else {
      await _saveBasicWord(word);
    }
  }

  /// Saves a basic word entry without detailed information
  Future<void> _saveBasicWord(String word) async {
    final userId = _userService.getUserId();
    if (userId == null) {
      _setError(StringConstants.userNotAuthenticated);
      return;
    }

    final documentId = _uuid.v4();

    final basicEntry = DictionaryEntry(
      documentId: documentId,
      word: word,
      meanings: const [],
      phonetics: const [],
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

  /// Saves a complete dictionary entry with all details
  Future<void> _saveFullDictionaryEntry(DictionaryEntry entry) async {
    final userId = _userService.getUserId();
    if (userId == null) {
      _setError(StringConstants.userNotAuthenticated);
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

  /// Sets loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets error message and notifies listeners
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears current error message
  void _clearError() {
    _errorMessage = null;
  }
}
