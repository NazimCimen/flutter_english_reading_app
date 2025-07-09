import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/get_words_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/search_words_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/add_word_to_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/update_word_in_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/delete_word_from_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';

import 'word_bank_viewmodel_test.mocks.dart';

@GenerateMocks([
  GetWordsUseCase,
  SearchWordsUseCase,
  AddWordToBankUseCase,
  UpdateWordInBankUseCase,
  DeleteWordFromBankUseCase,
])
void main() {
  late WordBankViewModel viewModel;
  late MockGetWordsUseCase mockGetWordsUseCase;
  late MockSearchWordsUseCase mockSearchWordsUseCase;
  late MockAddWordToBankUseCase mockAddWordToBankUseCase;
  late MockUpdateWordInBankUseCase mockUpdateWordInBankUseCase;
  late MockDeleteWordFromBankUseCase mockDeleteWordFromBankUseCase;

  setUp(() {
    mockGetWordsUseCase = MockGetWordsUseCase();
    mockSearchWordsUseCase = MockSearchWordsUseCase();
    mockAddWordToBankUseCase = MockAddWordToBankUseCase();
    mockUpdateWordInBankUseCase = MockUpdateWordInBankUseCase();
    mockDeleteWordFromBankUseCase = MockDeleteWordFromBankUseCase();
    
    viewModel = WordBankViewModel(
      getWordsUseCase: mockGetWordsUseCase,
      searchWordsUseCase: mockSearchWordsUseCase,
      addWordToBankUseCase: mockAddWordToBankUseCase,
      updateWordInBankUseCase: mockUpdateWordInBankUseCase,
      deleteWordFromBankUseCase: mockDeleteWordFromBankUseCase,
    );
  });

  group('success/fail test initialization and state management', () {
    test('success test should initialize with correct default values', () {
      //arrange
      //act
      //assert
      expect(viewModel.isLoading, false);
      expect(viewModel.isSearching, false);
      expect(viewModel.fetchedWords, isEmpty);
      expect(viewModel.searchedWords, isEmpty);
    });

    test('success test should update loading state correctly', () {
      //arrange
      //act
      viewModel.addListener(() {});
      //assert
      expect(viewModel.isLoading, false);
    });

    test('success test should update search state correctly', () {
      //arrange
      //act
      viewModel.setIsSearch(true);
      //assert
      expect(viewModel.isSearching, true);
    });
  });

  group('success/fail test fetchWords', () {
    test('success test should fetch words successfully and update state', () async {
      //arrange
      final tWords = [
        DictionaryEntry(word: 'test', meanings: []),
        DictionaryEntry(word: 'example', meanings: []),
      ];
      when(mockGetWordsUseCase(limit: 10, reset: false))
          .thenAnswer((_) async => Right(tWords));
      
      //act
      await viewModel.fetchWords();
      
      //assert
      expect(viewModel.fetchedWords, tWords);
      expect(viewModel.isLoading, false);
      verify(mockGetWordsUseCase(limit: 10, reset: false));
      verifyNoMoreInteractions(mockGetWordsUseCase);
    });

    test('success test should fetch words with custom parameters', () async {
      //arrange
      final tWords = [DictionaryEntry(word: 'test', meanings: [])];
      when(mockGetWordsUseCase(limit: 5, reset: true))
          .thenAnswer((_) async => Right(tWords));
      
      //act
      await viewModel.fetchWords(limit: 5, reset: true);
      
      //assert
      expect(viewModel.fetchedWords, tWords);
      expect(viewModel.isLoading, false);
      verify(mockGetWordsUseCase(limit: 5, reset: true));
      verifyNoMoreInteractions(mockGetWordsUseCase);
    });

    test('fail test should handle failure and not update words', () async {
      //arrange
      when(mockGetWordsUseCase(limit: 10, reset: false))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));
      
      //act
      await viewModel.fetchWords();
      
      //assert
      expect(viewModel.fetchedWords, isEmpty);
      expect(viewModel.isLoading, false);
      verify(mockGetWordsUseCase(limit: 10, reset: false));
      verifyNoMoreInteractions(mockGetWordsUseCase);
    });
  });

  group('success/fail test searchWords', () {
    test('success test should search words successfully and update state', () async {
      //arrange
      final tWords = [
        DictionaryEntry(word: 'test', meanings: []),
        DictionaryEntry(word: 'testing', meanings: []),
      ];
      when(mockSearchWordsUseCase('test'))
          .thenAnswer((_) async => Right(tWords));
      
      //act
      await viewModel.searchWords('test');
      
      //assert
      expect(viewModel.searchedWords, tWords);
      expect(viewModel.isSearching, false);
      verify(mockSearchWordsUseCase('test'));
      verifyNoMoreInteractions(mockSearchWordsUseCase);
    });

    test('success test should handle empty search results', () async {
      //arrange
      when(mockSearchWordsUseCase('nonexistent'))
          .thenAnswer((_) async => Right([]));
      
      //act
      await viewModel.searchWords('nonexistent');
      
      //assert
      expect(viewModel.searchedWords, isEmpty);
      expect(viewModel.isSearching, false);
      verify(mockSearchWordsUseCase('nonexistent'));
      verifyNoMoreInteractions(mockSearchWordsUseCase);
    });

    test('fail test should handle search failure and set searchedWords to null', () async {
      //arrange
      when(mockSearchWordsUseCase('test'))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Search failed')));
      
      //act
      await viewModel.searchWords('test');
      
      //assert
      expect(viewModel.searchedWords, isNull);
      expect(viewModel.isSearching, false);
      verify(mockSearchWordsUseCase('test'));
      verifyNoMoreInteractions(mockSearchWordsUseCase);
    });
  });

  group('success/fail test addWord', () {
    test('success test should add word successfully and return true', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: []);
      when(mockAddWordToBankUseCase(tWord))
          .thenAnswer((_) async => Right('doc123'));
      
      //act
      final result = await viewModel.addWord(tWord);
      
      //assert
      expect(result, true);
      expect(viewModel.isLoading, false);
      verify(mockAddWordToBankUseCase(tWord));
      verifyNoMoreInteractions(mockAddWordToBankUseCase);
    });

    test('fail test should handle add word failure and return false', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: []);
      when(mockAddWordToBankUseCase(tWord))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Add failed')));
      
      //act
      final result = await viewModel.addWord(tWord);
      
      //assert
      expect(result, false);
      expect(viewModel.isLoading, false);
      verify(mockAddWordToBankUseCase(tWord));
      verifyNoMoreInteractions(mockAddWordToBankUseCase);
    });
  });

  group('success/fail test updateWord', () {
    test('success test should update word successfully and return true', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [], documentId: 'doc123');
      when(mockUpdateWordInBankUseCase(tWord))
          .thenAnswer((_) async => const Right(null));
      
      //act
      final result = await viewModel.updateWord(tWord);
      
      //assert
      expect(result, true);
      expect(viewModel.isLoading, false);
      verify(mockUpdateWordInBankUseCase(tWord));
      verifyNoMoreInteractions(mockUpdateWordInBankUseCase);
    });

    test('fail test should handle update word failure and return false', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [], documentId: 'doc123');
      when(mockUpdateWordInBankUseCase(tWord))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Update failed')));
      
      //act
      final result = await viewModel.updateWord(tWord);
      
      //assert
      expect(result, false);
      expect(viewModel.isLoading, false);
      verify(mockUpdateWordInBankUseCase(tWord));
      verifyNoMoreInteractions(mockUpdateWordInBankUseCase);
    });
  });

  group('success/fail test deleteWord', () {
    test('success test should delete word successfully and return true', () async {
      //arrange
      when(mockDeleteWordFromBankUseCase('doc123'))
          .thenAnswer((_) async => const Right(null));
      
      //act
      final result = await viewModel.deleteWord('doc123');
      
      //assert
      expect(result, true);
      expect(viewModel.isLoading, false);
      verify(mockDeleteWordFromBankUseCase('doc123'));
      verifyNoMoreInteractions(mockDeleteWordFromBankUseCase);
    });

    test('fail test should handle delete word failure and return false', () async {
      //arrange
      when(mockDeleteWordFromBankUseCase('doc123'))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Delete failed')));
      
      //act
      final result = await viewModel.deleteWord('doc123');
      
      //assert
      expect(result, false);
      expect(viewModel.isLoading, false);
      verify(mockDeleteWordFromBankUseCase('doc123'));
      verifyNoMoreInteractions(mockDeleteWordFromBankUseCase);
    });
  });
}
