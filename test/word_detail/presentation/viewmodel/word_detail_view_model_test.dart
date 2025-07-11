// ignore_for_file: inference_failure_on_instance_creation
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_api_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_firestore_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/save_word_to_local_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/is_word_saved_usecase.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/product/services/user_service.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

import 'word_detail_view_model_test.mocks.dart';

@GenerateMocks([
  GetWordDetailFromApiUseCase,
  GetWordDetailFromFirestoreUseCase,
  SaveWordToLocalUseCase,
  IsWordSavedUseCase,
  UserService,
])
void main() {
  late WordDetailViewModel viewModel;
  late MockGetWordDetailFromApiUseCase mockGetWordDetailFromApiUseCase;
  late MockGetWordDetailFromLocalUseCase mockGetWordDetailFromLocalUseCase;
  late MockSaveWordToLocalUseCase mockSaveWordToLocalUseCase;
  late MockIsWordSavedUseCase mockIsWordSavedUseCase;
  late MockUserService mockUserService;

  setUp(() {
    mockGetWordDetailFromApiUseCase = MockGetWordDetailFromApiUseCase();
    mockGetWordDetailFromLocalUseCase = MockGetWordDetailFromLocalUseCase();
    mockSaveWordToLocalUseCase = MockSaveWordToLocalUseCase();
    mockIsWordSavedUseCase = MockIsWordSavedUseCase();
    mockUserService = MockUserService();
    
    viewModel = WordDetailViewModel(
      getWordDetailFromApiUseCase: mockGetWordDetailFromApiUseCase,
      getWordDetailFromLocalUseCase: mockGetWordDetailFromLocalUseCase,
      saveWordToLocalUseCase: mockSaveWordToLocalUseCase,
      isWordSavedUseCase: mockIsWordSavedUseCase,
      userService: mockUserService,
    );
  });

  const tWord = 'test';
  const tUserId = 'userId';
  final tEntry = DictionaryEntry(word: tWord, meanings: [], phonetics: []);
  const tDocId = 'docId';

  group('success test load word detail from api', () {
    test('success test should load word detail when use case call is successful', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(tUserId);
      when(mockIsWordSavedUseCase(tWord, tUserId))
          .thenAnswer((_) async => const Right(true));
      when(mockGetWordDetailFromApiUseCase(tWord))
          .thenAnswer((_) async => Right(tEntry));
      // act
      await viewModel.loadWordDetail(word: tWord, source: WordDetailSource.api);
      // assert
      expect(viewModel.wordDetail, tEntry);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.isSaved, true);
      verify(mockGetWordDetailFromApiUseCase(tWord));
      verify(mockIsWordSavedUseCase(tWord, tUserId));
      verifyNoMoreInteractions(mockGetWordDetailFromApiUseCase);
      verifyNoMoreInteractions(mockIsWordSavedUseCase);
    });
  });

  group('success test load word detail from local', () {
    test('success test should load word detail when use case call is successful', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(tUserId);
      when(mockIsWordSavedUseCase(tWord, tUserId))
          .thenAnswer((_) async => const Right(false));
      when(mockGetWordDetailFromLocalUseCase(tWord))
          .thenAnswer((_) async => Right(tEntry));
      // act
      await viewModel.loadWordDetail(word: tWord, source: WordDetailSource.local);
      // assert
      expect(viewModel.wordDetail, tEntry);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.isSaved, false);
      verify(mockGetWordDetailFromLocalUseCase(tWord));
      verify(mockIsWordSavedUseCase(tWord, tUserId));
      verifyNoMoreInteractions(mockGetWordDetailFromLocalUseCase);
      verifyNoMoreInteractions(mockIsWordSavedUseCase);
    });
  });

  group('fail test load word detail', () {
    test('fail test should handle error when use case call fails', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(tUserId);
      when(mockIsWordSavedUseCase(tWord, tUserId))
          .thenAnswer((_) async => const Right(false));
      when(mockGetWordDetailFromApiUseCase(tWord))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));
      // act
      await viewModel.loadWordDetail(word: tWord, source: WordDetailSource.api);
      // assert
      expect(viewModel.wordDetail, null);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, 'error');
      verify(mockGetWordDetailFromApiUseCase(tWord));
      verify(mockIsWordSavedUseCase(tWord, tUserId));
      verifyNoMoreInteractions(mockGetWordDetailFromApiUseCase);
      verifyNoMoreInteractions(mockIsWordSavedUseCase);
    });

    test('fail test should handle error when user is not authenticated', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(null);
      when(mockGetWordDetailFromApiUseCase(tWord))
          .thenAnswer((_) async => Right(tEntry));
      // act
      await viewModel.loadWordDetail(word: tWord, source: WordDetailSource.api);
      // assert
      expect(viewModel.wordDetail, tEntry);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.isSaved, false);
      verify(mockGetWordDetailFromApiUseCase(tWord));
      verifyZeroInteractions(mockIsWordSavedUseCase);
      verifyNoMoreInteractions(mockGetWordDetailFromApiUseCase);
    });
  });

  group('success test save word', () {
    test('success test should save word when user is authenticated and word detail exists', () async {
      // arrange
      viewModel = WordDetailViewModel(
        getWordDetailFromApiUseCase: mockGetWordDetailFromApiUseCase,
        getWordDetailFromLocalUseCase: mockGetWordDetailFromLocalUseCase,
        saveWordToLocalUseCase: mockSaveWordToLocalUseCase,
        isWordSavedUseCase: mockIsWordSavedUseCase,
        userService: mockUserService,
      );
      
      // Set word detail
      when(mockUserService.getUserId()).thenReturn(tUserId);
      when(mockIsWordSavedUseCase(tWord, tUserId))
          .thenAnswer((_) async => const Right(false));
      when(mockGetWordDetailFromApiUseCase(tWord))
          .thenAnswer((_) async => Right(tEntry));
      await viewModel.loadWordDetail(word: tWord, source: WordDetailSource.api);
      
      // Save word
      when(mockUserService.getUserId()).thenReturn(tUserId);
      when(mockSaveWordToLocalUseCase(any))
          .thenAnswer((_) async => Right(tDocId));
      // act
      await viewModel.saveWord(tWord);
      // assert
      expect(viewModel.isSaved, true);
      expect(viewModel.errorMessage, null);
      verify(mockSaveWordToLocalUseCase(any));
      verifyNoMoreInteractions(mockSaveWordToLocalUseCase);
    });

    test('success test should save basic word when user is authenticated and no word detail exists', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(tUserId);
      when(mockSaveWordToLocalUseCase(any))
          .thenAnswer((_) async => Right(tDocId));
      // act
      await viewModel.saveWord(tWord);
      // assert
      expect(viewModel.isSaved, true);
      expect(viewModel.errorMessage, null);
      verify(mockSaveWordToLocalUseCase(any));
      verifyNoMoreInteractions(mockSaveWordToLocalUseCase);
    });
  });

  group('fail test save word', () {
    test('fail test should handle error when user is not authenticated', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(null);
      // act
      await viewModel.saveWord(tWord);
      // assert
      expect(viewModel.errorMessage, 'User not authenticated');
      verifyZeroInteractions(mockSaveWordToLocalUseCase);
    });

    test('fail test should handle error when save use case fails', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(tUserId);
      when(mockSaveWordToLocalUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));
      // act
      await viewModel.saveWord(tWord);
      // assert
      expect(viewModel.errorMessage, 'error');
      verify(mockSaveWordToLocalUseCase(any));
      verifyNoMoreInteractions(mockSaveWordToLocalUseCase);
    });
  });
} 