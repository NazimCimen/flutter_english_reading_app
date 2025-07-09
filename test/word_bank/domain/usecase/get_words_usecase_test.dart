import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/get_words_usecase.dart';

import 'get_words_usecase_test.mocks.dart';

@GenerateMocks([WordBankRepository])
void main() {
  late GetWordsUseCase useCase;
  late MockWordBankRepository mockRepository;

  setUp(() {
    mockRepository = MockWordBankRepository();
    useCase = GetWordsUseCase(repository: mockRepository);
  });

  group('success/fail test GetWordsUseCase', () {
    group('success test', () {
      test('success test should return list of words when repository call is successful', () async {
        //arrange
        final tWords = [
          DictionaryEntry(word: 'test', meanings: []),
          DictionaryEntry(word: 'example', meanings: []),
        ];
        when(mockRepository.getWords(limit: 10, reset: false))
            .thenAnswer((_) async => Right(tWords));

        //act
        final result = await useCase(limit: 10, reset: false);

        //assert
        expect(result, Right(tWords));
        verify(mockRepository.getWords(limit: 10, reset: false));
        verifyNoMoreInteractions(mockRepository);
      });

      test('success test should return list of words with custom limit and reset', () async {
        //arrange
        final tWords = [DictionaryEntry(word: 'test', meanings: [])];
        when(mockRepository.getWords(limit: 5, reset: true))
            .thenAnswer((_) async => Right(tWords));

        //act
        final result = await useCase(limit: 5, reset: true);

        //assert
        expect(result, Right(tWords));
        verify(mockRepository.getWords(limit: 5, reset: true));
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('fail test', () {
      test('fail test should return InputNoImageFailure when limit is zero', () async {
        //arrange
        //act
        final result = await useCase(limit: 0);

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
        verifyZeroInteractions(mockRepository);
      });

      test('fail test should return InputNoImageFailure when limit is negative', () async {
        //arrange
        //act
        final result = await useCase(limit: -5);

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
        verifyZeroInteractions(mockRepository);
      });

      test('fail test should return InputNoImageFailure when limit is greater than 100', () async {
        //arrange
        //act
        final result = await useCase(limit: 150);

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
        verifyZeroInteractions(mockRepository);
      });

      test('fail test should return ServerFailure when repository call fails', () async {
        //arrange
        when(mockRepository.getWords(limit: 10, reset: false))
            .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

        //act
        final result = await useCase(limit: 10, reset: false);

        //assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
        verify(mockRepository.getWords(limit: 10, reset: false));
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
} 