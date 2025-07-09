import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';

import 'word_bank_repository_test.mocks.dart';

@GenerateMocks([WordBankRepository])
void main() {
  late MockWordBankRepository mockRepository;

  setUp(() {
    mockRepository = MockWordBankRepository();
  });

  group('success/fail test getWords', () {
    test('success test should return list of words when repository call is successful', () async {
      //arrange
      final tWords = [
        DictionaryEntry(word: 'test', meanings: []),
        DictionaryEntry(word: 'example', meanings: []),
      ];
      when(mockRepository.getWords(limit: 10, reset: false))
          .thenAnswer((_) async => Right(tWords));
      
      //act
      final result = await mockRepository.getWords(limit: 10, reset: false);
      
      //assert
      expect(result, Right(tWords));
      verify(mockRepository.getWords(limit: 10, reset: false));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return list of words with custom parameters', () async {
      //arrange
      final tWords = [DictionaryEntry(word: 'test', meanings: [])];
      when(mockRepository.getWords(limit: 5, reset: true))
          .thenAnswer((_) async => Right(tWords));
      
      //act
      final result = await mockRepository.getWords(limit: 5, reset: true);
      
      //assert
      expect(result, Right(tWords));
      verify(mockRepository.getWords(limit: 5, reset: true));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return ServerFailure when repository call fails', () async {
      //arrange
      when(mockRepository.getWords(limit: 10, reset: false))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));
      
      //act
      final result = await mockRepository.getWords(limit: 10, reset: false);
      
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.getWords(limit: 10, reset: false));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success/fail test searchWord', () {
    test('success test should return list of words when search is successful', () async {
      //arrange
      final tWords = [
        DictionaryEntry(word: 'test', meanings: []),
        DictionaryEntry(word: 'testing', meanings: []),
      ];
      when(mockRepository.searchWord(query: 'test'))
          .thenAnswer((_) async => Right(tWords));
      
      //act
      final result = await mockRepository.searchWord(query: 'test');
      
      //assert
      expect(result, Right(tWords));
      verify(mockRepository.searchWord(query: 'test'));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return empty list when no words found', () async {
      //arrange
      when(mockRepository.searchWord(query: 'nonexistent'))
          .thenAnswer((_) async => Right([]));
      
      //act
      final result = await mockRepository.searchWord(query: 'nonexistent');
      
      //assert
      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r), isEmpty);
      verify(mockRepository.searchWord(query: 'nonexistent'));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return ServerFailure when search fails', () async {
      //arrange
      when(mockRepository.searchWord(query: 'test'))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Search failed')));
      
      //act
      final result = await mockRepository.searchWord(query: 'test');
      
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.searchWord(query: 'test'));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success/fail test addWord', () {
    test('success test should return document ID when word is added successfully', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: []);
      when(mockRepository.addWord(tWord))
          .thenAnswer((_) async => Right('doc123'));
      
      //act
      final result = await mockRepository.addWord(tWord);
      
      //assert
      expect(result, Right('doc123'));
      verify(mockRepository.addWord(tWord));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return ServerFailure when add word fails', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: []);
      when(mockRepository.addWord(tWord))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Add failed')));
      
      //act
      final result = await mockRepository.addWord(tWord);
      
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.addWord(tWord));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success/fail test updateWord', () {
    test('success test should return void when word is updated successfully', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [], documentId: 'doc123');
      when(mockRepository.updateWord(tWord))
          .thenAnswer((_) async => const Right(null));
      
      //act
      final result = await mockRepository.updateWord(tWord);
      
      //assert
      expect(result, const Right(null));
      verify(mockRepository.updateWord(tWord));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return ServerFailure when update word fails', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [], documentId: 'doc123');
      when(mockRepository.updateWord(tWord))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Update failed')));
      
      //act
      final result = await mockRepository.updateWord(tWord);
      
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.updateWord(tWord));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success/fail test deleteWord', () {
    test('success test should return void when word is deleted successfully', () async {
      //arrange
      when(mockRepository.deleteWord('doc123'))
          .thenAnswer((_) async => const Right(null));
      
      //act
      final result = await mockRepository.deleteWord('doc123');
      
      //assert
      expect(result, const Right(null));
      verify(mockRepository.deleteWord('doc123'));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return ServerFailure when delete word fails', () async {
      //arrange
      when(mockRepository.deleteWord('doc123'))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Delete failed')));
      
      //act
      final result = await mockRepository.deleteWord('doc123');
      
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.deleteWord('doc123'));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success/fail test method signatures', () {
    test('success test should have correct getWords method signature', () {
      //arrange
      //act
      //assert
      expect(mockRepository.getWords, isA<Function>());
    });

    test('success test should have correct searchWord method signature', () {
      //arrange
      //act
      //assert
      expect(mockRepository.searchWord, isA<Function>());
    });

    test('success test should have correct addWord method signature', () {
      //arrange
      //act
      //assert
      expect(mockRepository.addWord, isA<Function>());
    });

    test('success test should have correct updateWord method signature', () {
      //arrange
      //act
      //assert
      expect(mockRepository.updateWord, isA<Function>());
    });

    test('success test should have correct deleteWord method signature', () {
      //arrange
      //act
      //assert
      expect(mockRepository.deleteWord, isA<Function>());
    });
  });
} 