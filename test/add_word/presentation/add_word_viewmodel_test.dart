import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';
import 'package:english_reading_app/feature/add_word/domain/usecase/save_word_usecase.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/error/failure.dart';

import 'add_word_viewmodel_test.mocks.dart';

@GenerateMocks([SaveWordUseCase])
void main() {
  late AddWordViewModel addWordViewModel;
  late MockSaveWordUseCase mockSaveWordUseCase;

  setUp(
    () {
      mockSaveWordUseCase = MockSaveWordUseCase();
      addWordViewModel = AddWordViewModel(mockSaveWordUseCase);
    },
  );

  group(
    'succes/fail test add word view model initialization and state management',
    () {
      test(
        'succes test initial state',
        () {
          //arrange
          //act
          //assert
          expect(addWordViewModel.word, '');
          expect(addWordViewModel.meanings, isEmpty);
          expect(addWordViewModel.isLoading, false);
        },
      );

      test(
        'succes test set word',
        () {
          //arrange
          const testWord = 'test';
          //act
          addWordViewModel.setWord(testWord);
          //assert
          expect(addWordViewModel.word, testWord);
        },
      );

      test(
        'succes test set meanings',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'test definition')],
            ),
          ];
          //act
          addWordViewModel.setMeanings(testMeanings);
          //assert
          expect(addWordViewModel.meanings.length, testMeanings.length);
          expect(addWordViewModel.meanings.first.partOfSpeech, testMeanings.first.partOfSpeech);
          expect(addWordViewModel.meanings.first.definitions.first.definition, testMeanings.first.definitions.first.definition);
          expect(addWordViewModel.meanings.first.id, isNotNull);
        },
      );

      test(
        'succes test clean meanings',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'test definition')],
            ),
          ];
          addWordViewModel.setMeanings(testMeanings);
          //act
          addWordViewModel.cleanMeanings();
          //assert
          expect(addWordViewModel.meanings, isEmpty);
        },
      );
    },
  );

  group(
    'succes/fail test add word view model meaning management operations',
    () {
      test(
        'succes test add new meaning',
        () {
          //arrange
          final initialMeanings = [
            Meaning(
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'test definition')],
            ),
          ];
          addWordViewModel.setMeanings(initialMeanings);
          //act
          addWordViewModel.addNewMeaning();
          //assert
          expect(addWordViewModel.meanings.length, 2);
          expect(addWordViewModel.meanings.first.partOfSpeech, '');
          expect(addWordViewModel.meanings.first.definitions.length, 1);
        },
      );

      test(
        'succes test remove meaning',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              id: '1',
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'test definition')],
            ),
            Meaning(
              id: '2',
              partOfSpeech: 'verb',
              definitions: [Definition(definition: 'test definition 2')],
            ),
          ];
          addWordViewModel.setMeanings(testMeanings);
          //act
          addWordViewModel.removeMeaningById('1');
          //assert
          expect(addWordViewModel.meanings.length, 1);
          expect(addWordViewModel.meanings.first.id, '2');
        },
      );

      test(
        'succes test update meaning part of speech',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              id: '1',
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'test definition')],
            ),
          ];
          addWordViewModel.setMeanings(testMeanings);
          //act
          addWordViewModel.updateMeaningPartOfSpeech('1', 'verb');
          //assert
          expect(addWordViewModel.meanings.first.partOfSpeech, 'verb');
        },
      );

      test(
        'succes test add definition to meaning',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              id: '1',
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'first definition')],
            ),
          ];
          addWordViewModel.setMeanings(testMeanings);
          //act
          addWordViewModel.addDefinitionToMeaning('1');
          //assert
          expect(addWordViewModel.meanings.first.definitions.length, 2);
          expect(addWordViewModel.meanings.first.definitions.last.definition, '');
        },
      );

      test(
        'succes test remove definition from meaning',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              id: '1',
              partOfSpeech: 'noun',
              definitions: [
                Definition(definition: 'first definition'),
                Definition(definition: 'second definition'),
              ],
            ),
          ];
          addWordViewModel.setMeanings(testMeanings);
          //act
          addWordViewModel.removeDefinitionFromMeaning('1', 0);
          //assert
          expect(addWordViewModel.meanings.first.definitions.length, 1);
          expect(addWordViewModel.meanings.first.definitions.first.definition, 'second definition');
        },
      );

      test(
        'succes test not remove last definition from meaning',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              id: '1',
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'only definition')],
            ),
          ];
          addWordViewModel.setMeanings(testMeanings);
          //act
          addWordViewModel.removeDefinitionFromMeaning('1', 0);
          //assert
          expect(addWordViewModel.meanings.first.definitions.length, 1);
          expect(addWordViewModel.meanings.first.definitions.first.definition, 'only definition');
        },
      );

      test(
        'succes test update definition',
        () {
          //arrange
          final testMeanings = [
            Meaning(
              id: '1',
              partOfSpeech: 'noun',
              definitions: [Definition(definition: 'old definition')],
            ),
          ];
          addWordViewModel.setMeanings(testMeanings);
          //act
          addWordViewModel.updateDefinition('1', 0, 'new definition');
          //assert
          expect(addWordViewModel.meanings.first.definitions.first.definition, 'new definition');
        },
      );
    },
  );

  group(
    'succes/fail test add word view model save word operation',
    () {
      const testWord = 'test';
      final testMeanings = [
        Meaning(
          partOfSpeech: 'noun',
          definitions: [Definition(definition: 'test definition')],
        ),
      ];
      final expectedDictionaryEntry = DictionaryEntry(
        word: testWord,
        meanings: testMeanings,
        createdAt: DateTime.now(),
      );

      test(
        'succes test save word',
        () async {
          //arrange
          addWordViewModel.setWord(testWord);
          addWordViewModel.setMeanings(testMeanings);
          when(mockSaveWordUseCase(any))
              .thenAnswer((_) async => Right(expectedDictionaryEntry));
          //act
          final result = await addWordViewModel.saveWord();
          //assert
          // ignore: inference_failure_on_instance_creation
          expect(result, Right(expectedDictionaryEntry));
          verify(mockSaveWordUseCase(any)).called(1);
        },
      );

      test(
        'fail test save word server failure',
        () async {
          //arrange
          addWordViewModel.setWord(testWord);
          addWordViewModel.setMeanings(testMeanings);
          when(mockSaveWordUseCase(any))
              .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));
          //act
          final result = await addWordViewModel.saveWord();
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(failure.errorMessage, 'Server error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockSaveWordUseCase(any)).called(1);
        },
      );

      test(
        'fail test save word connection failure',
        () async {
          //arrange
          addWordViewModel.setWord(testWord);
          addWordViewModel.setMeanings(testMeanings);
          when(mockSaveWordUseCase(any))
              .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));
          //act
          final result = await addWordViewModel.saveWord();
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ConnectionFailure>());
              expect(failure.errorMessage, 'Connection error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockSaveWordUseCase(any)).called(1);
        },
      );

      test(
        'fail test save word unknown failure',
        () async {
          //arrange
          addWordViewModel.setWord(testWord);
          addWordViewModel.setMeanings(testMeanings);
          when(mockSaveWordUseCase(any))
              .thenAnswer((_) async => Left(UnKnownFaliure(errorMessage: 'Unknown error')));
          //act
          final result = await addWordViewModel.saveWord();
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<UnKnownFaliure>());
              expect(failure.errorMessage, 'Unknown error');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockSaveWordUseCase(any)).called(1);
        },
      );
    },
  );
}
