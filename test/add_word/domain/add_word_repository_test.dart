import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/feature/add_word/domain/repository/add_word_repository.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/error/failure.dart';

import 'add_word_repository_test.mocks.dart';

@GenerateMocks([
  AddWordRepository,
])
void main() {
  late MockAddWordRepository mockAddWordRepository;

  setUp(
    () {
      mockAddWordRepository = MockAddWordRepository();
    },
  );

  group(
    'succes/fail test add word repository contract save word method',
    () {
      const testWord = 'test';
      final testMeanings = [
        Meaning(
          partOfSpeech: 'noun',
          definitions: [Definition(definition: 'test definition')],
        ),
      ];
      final testDictionaryEntry = DictionaryEntry(
        word: testWord,
        meanings: testMeanings,
        createdAt: DateTime.now(),
      );
      final savedDictionaryEntry = testDictionaryEntry.copyWith(
        documentId: 'test_document_id',
        userId: 'test_user_id',
      );

      test(
        'succes test',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(testDictionaryEntry))
              .thenAnswer((_) async => Right(savedDictionaryEntry));
          //act
          final result = await mockAddWordRepository.saveWord(testDictionaryEntry);
          //assert
          // ignore: inference_failure_on_instance_creation
          expect(result, Right(savedDictionaryEntry));
          verify(mockAddWordRepository.saveWord(testDictionaryEntry));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );

      test(
        'fail test server failure',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(testDictionaryEntry))
              .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));
          //act
          final result = await mockAddWordRepository.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(failure.errorMessage, 'Server error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAddWordRepository.saveWord(testDictionaryEntry));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );

      test(
        'fail test connection failure',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(testDictionaryEntry))
              .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));
          //act
          final result = await mockAddWordRepository.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ConnectionFailure>());
              expect(failure.errorMessage, 'Connection error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAddWordRepository.saveWord(testDictionaryEntry));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );

      test(
        'fail test unknown failure',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(testDictionaryEntry))
              .thenAnswer((_) async => Left(UnKnownFaliure(errorMessage: 'Unknown error')));
          //act
          final result = await mockAddWordRepository.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<UnKnownFaliure>());
              expect(failure.errorMessage, 'Unknown error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAddWordRepository.saveWord(testDictionaryEntry));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );
    },
  );

  group(
    'succes/fail test add word repository contract method signature validation',
    () {
      const testWord = 'test';
      final testMeanings = [
        Meaning(
          partOfSpeech: 'noun',
          definitions: [Definition(definition: 'test definition')],
        ),
      ];
      final testDictionaryEntry = DictionaryEntry(
        word: testWord,
        meanings: testMeanings,
        createdAt: DateTime.now(),
      );

      test(
        'succes test method signature validation',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(any))
              .thenAnswer((_) async => Right(testDictionaryEntry));
          //act
          final result = await mockAddWordRepository.saveWord(testDictionaryEntry);
          //assert
          expect(result.isRight(), isTrue);
          result.fold(
            (failure) => fail('Should not reach here'),
            (dictionaryEntry) {
              expect(dictionaryEntry, isA<DictionaryEntry>());
              expect(dictionaryEntry.word, testWord);
            },
          );
          verify(mockAddWordRepository.saveWord(testDictionaryEntry));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );

      test(
        'fail test method signature validation with failure',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(any))
              .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Test error')));
          //act
          final result = await mockAddWordRepository.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<Failure>());
              expect(failure.errorMessage, 'Test error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAddWordRepository.saveWord(testDictionaryEntry));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );
    },
  );
}
