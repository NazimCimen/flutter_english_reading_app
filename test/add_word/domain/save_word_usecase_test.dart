import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/feature/add_word/domain/usecase/save_word_usecase.dart';
import 'package:english_reading_app/feature/add_word/domain/repository/add_word_repository.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/error/failure.dart';

import 'save_word_usecase_test.mocks.dart';

@GenerateMocks([
  AddWordRepository,
])
void main() {
  late SaveWordUseCase saveWordUseCase;
  late MockAddWordRepository mockAddWordRepository;

  setUp(
    () {
      mockAddWordRepository = MockAddWordRepository();
      saveWordUseCase = SaveWordUseCase(repository: mockAddWordRepository);
    },
  );

  group(
    'succes/fail test save word use case with valid input data',
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
      );
      final savedDictionaryEntry = testDictionaryEntry.copyWith(
        documentId: 'test_document_id',
        userId: 'test_user_id',
        createdAt: DateTime.now(),
      );

      test(
        'succes test',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(any))
              .thenAnswer((_) async => Right(savedDictionaryEntry));
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          // ignore: inference_failure_on_instance_creation
          expect(result, Right(savedDictionaryEntry));
          verify(mockAddWordRepository.saveWord(any));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );

      test(
        'fail test server failure',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(any))
              .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(failure.errorMessage, 'Server error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAddWordRepository.saveWord(any));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );

      test(
        'fail test connection failure',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(any))
              .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ConnectionFailure>());
              expect(failure.errorMessage, 'Connection error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAddWordRepository.saveWord(any));
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );
    },
  );

  group(
    'succes/fail test save word use case with invalid input data validation',
    () {
      test(
        'fail test empty word',
        () async {
          //arrange
          final testDictionaryEntry = DictionaryEntry(
            word: '',
            meanings: [
              Meaning(
                partOfSpeech: 'noun',
                definitions: [Definition(definition: 'test definition')],
              ),
            ],
          );
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<InputNoImageFailure>());
              expect(failure.errorMessage, 'Kelime boş olamaz');
            },
            (_) => fail('Should not reach here'),
          );
          verifyNever(mockAddWordRepository.saveWord(any));
        },
      );

      test(
        'fail test null word',
        () async {
          //arrange
          final testDictionaryEntry = DictionaryEntry(
            word: null,
            meanings: [
              Meaning(
                partOfSpeech: 'noun',
                definitions: [Definition(definition: 'test definition')],
              ),
            ],
          );
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<InputNoImageFailure>());
              expect(failure.errorMessage, 'Kelime boş olamaz');
            },
            (_) => fail('Should not reach here'),
          );
          verifyNever(mockAddWordRepository.saveWord(any));
        },
      );

      test(
        'fail test empty meanings list',
        () async {
          //arrange
          final testDictionaryEntry = DictionaryEntry(
            word: 'test',
            meanings: [],
          );
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<InputNoImageFailure>());
              expect(failure.errorMessage, 'En az bir anlam eklenmelidir');
            },
            (_) => fail('Should not reach here'),
          );
          verifyNever(mockAddWordRepository.saveWord(any));
        },
      );

      test(
        'fail test null meanings list',
        () async {
          //arrange
          final testDictionaryEntry = DictionaryEntry(
            word: 'test',
            meanings: null,
          );
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<InputNoImageFailure>());
              expect(failure.errorMessage, 'En az bir anlam eklenmelidir');
            },
            (_) => fail('Should not reach here'),
          );
          verifyNever(mockAddWordRepository.saveWord(any));
        },
      );

      test(
        'fail test empty part of speech',
        () async {
          //arrange
          final testDictionaryEntry = DictionaryEntry(
            word: 'test',
            meanings: [
              Meaning(
                partOfSpeech: '',
                definitions: [Definition(definition: 'test definition')],
              ),
            ],
          );
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<InputNoImageFailure>());
              expect(failure.errorMessage, 'Kelime türü boş olamaz');
            },
            (_) => fail('Should not reach here'),
          );
          verifyNever(mockAddWordRepository.saveWord(any));
        },
      );

      test(
        'fail test empty definitions list',
        () async {
          //arrange
          final testDictionaryEntry = DictionaryEntry(
            word: 'test',
            meanings: [
              Meaning(
                partOfSpeech: 'noun',
                definitions: [],
              ),
            ],
          );
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<InputNoImageFailure>());
              expect(failure.errorMessage, 'Her anlam için en az bir tanım gereklidir');
            },
            (_) => fail('Should not reach here'),
          );
          verifyNever(mockAddWordRepository.saveWord(any));
        },
      );

      test(
        'fail test empty definition text',
        () async {
          //arrange
          final testDictionaryEntry = DictionaryEntry(
            word: 'test',
            meanings: [
              Meaning(
                partOfSpeech: 'noun',
                definitions: [Definition(definition: '')],
              ),
            ],
          );
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<InputNoImageFailure>());
              expect(failure.errorMessage, 'Tanım boş olamaz');
            },
            (_) => fail('Should not reach here'),
          );
          verifyNever(mockAddWordRepository.saveWord(any));
        },
      );
    },
  );

  group(
    'succes/fail test save word use case metadata addition',
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
      );

      test(
        'succes test metadata addition',
        () async {
          //arrange
          when(mockAddWordRepository.saveWord(any))
              .thenAnswer((_) async => Right(testDictionaryEntry));
          //act
          final result = await saveWordUseCase(testDictionaryEntry);
          //assert
          expect(result.isRight(), isTrue);
          result.fold(
            (failure) => fail('Should not reach here'),
            (savedWord) {
              expect(savedWord.word, testWord);
              expect(savedWord.meanings, testMeanings);
            },
          );
          verify(mockAddWordRepository.saveWord(any)).called(1);
          verifyNoMoreInteractions(mockAddWordRepository);
        },
      );
    },
  );
}
