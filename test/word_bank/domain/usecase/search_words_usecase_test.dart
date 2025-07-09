import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/search_words_usecase.dart';

import 'search_words_usecase_test.mocks.dart';

@GenerateMocks([WordBankRepository])
void main() {
  late SearchWordsUseCase useCase;
  late MockWordBankRepository mockRepository;

  setUp(() {
    mockRepository = MockWordBankRepository();
    useCase = SearchWordsUseCase(repository: mockRepository);
  });

  group('success/fail test SearchWordsUseCase', () {
    group('success test', () {
      test('success test should return list of words when repository call is successful', () async {
        //arrange
        final tWords = [
          DictionaryEntry(word: 'test', meanings: []),
          DictionaryEntry(word: 'testing', meanings: []),
        ];
        when(mockRepository.searchWord(query: 'test'))
            .thenAnswer((_) async => Right(tWords));

        //act
        final result = await useCase('test');

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
        final result = await useCase('nonexistent');

        //assert
        expect(result.isRight(), true);
        expect(result.fold((l) => null, (r) => r), isEmpty);
        verify(mockRepository.searchWord(query: 'nonexistent'));
        verifyNoMoreInteractions(mockRepository);
      });

      test('success test should trim whitespace from query', () async {
        //arrange
        final tWords = [DictionaryEntry(word: 'test', meanings: [])];
        when(mockRepository.searchWord(query: 'test'))
            .thenAnswer((_) async => Right(tWords));

        //act
        final result = await useCase('  test  ');

        //assert
        expect(result, Right(tWords));
        verify(mockRepository.searchWord(query: 'test'));
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('fail test', () {
      test('fail test should return InputNoImageFailure when query is empty', () async {
        //arrange
        //act
        final result = await useCase('');

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
        verifyZeroInteractions(mockRepository);
      });

      test('fail test should return InputNoImageFailure when query is only whitespace', () async {
        //arrange
        //act
        final result = await useCase('   ');

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
        verifyZeroInteractions(mockRepository);
      });

      test('fail test should return InputNoImageFailure when query is less than 2 characters', () async {
        //arrange
        //act
        final result = await useCase('a');

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
        verifyZeroInteractions(mockRepository);
      });

      test('fail test should return InputNoImageFailure when query is longer than 50 characters', () async {
        //arrange
        final longQuery = 'a' * 51;
        //act
        final result = await useCase(longQuery);

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
        verifyZeroInteractions(mockRepository);
      });

      test('fail test should return ServerFailure when repository call fails', () async {
        //arrange
        when(mockRepository.searchWord(query: 'test'))
            .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

        //act
        final result = await useCase('test');

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
        verify(mockRepository.searchWord(query: 'test'));
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
} 