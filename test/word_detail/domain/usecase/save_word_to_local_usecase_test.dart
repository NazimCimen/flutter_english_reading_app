// ignore_for_file: inference_failure_on_instance_creation
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/save_word_to_local_usecase.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

import 'save_word_to_local_usecase_test.mocks.dart';

@GenerateMocks([WordDetailRepository])
void main() {
  late SaveWordToLocalUseCase useCase;
  late MockWordDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockWordDetailRepository();
    useCase = SaveWordToLocalUseCase(mockRepository);
  });

  final tEntry = DictionaryEntry(
    word: 'test', 
    meanings: [Meaning(partOfSpeech: 'noun', definitions: [])], 
    phonetics: []
  );
  const tDocId = 'docId';

  group('success test save word to local', () {
    test('success test should return docId when repository call is successful', () async {
      // arrange
      when(mockRepository.saveWordToLocal(tEntry))
          .thenAnswer((_) async => Right(tDocId));
      // act
      final result = await useCase(tEntry);
      // assert
      expect(result, Right(tDocId));
      verify(mockRepository.saveWordToLocal(tEntry));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test save word to local', () {
    test('fail test should return failure when repository call fails', () async {
      // arrange
      when(mockRepository.saveWordToLocal(tEntry))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));
      // act
      final result = await useCase(tEntry);
      // assert
      expect(result, isA<Left<Failure, String>>());
      verify(mockRepository.saveWordToLocal(tEntry));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return failure when word is empty', () async {
      // arrange
      final emptyEntry = DictionaryEntry(
        word: '', 
        meanings: [Meaning(partOfSpeech: 'noun', definitions: [])], 
        phonetics: []
      );
      // act
      final result = await useCase(emptyEntry);
      // assert
      expect(result, isA<Left<Failure, String>>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return failure when meanings is empty', () async {
      // arrange
      final entryNoMeanings = DictionaryEntry(word: 'test', meanings: [], phonetics: []);
      // act
      final result = await useCase(entryNoMeanings);
      // assert
      expect(result, isA<Left<Failure, String>>());
      verifyZeroInteractions(mockRepository);
    });
  });
} 