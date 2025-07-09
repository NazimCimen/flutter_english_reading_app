// ignore_for_file: inference_failure_on_instance_creation
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_local_usecase.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

import 'get_word_detail_from_local_usecase_test.mocks.dart';

@GenerateMocks([WordDetailRepository])
void main() {
  late GetWordDetailFromLocalUseCase useCase;
  late MockWordDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockWordDetailRepository();
    useCase = GetWordDetailFromLocalUseCase(mockRepository);
  });

  const tWord = 'test';
  final tEntry = DictionaryEntry(word: tWord, meanings: [], phonetics: []);

  group('success test get word detail from local', () {
    test('success test should return entry when repository call is successful', () async {
      // arrange
      when(mockRepository.getWordDetailFromLocal(tWord))
          .thenAnswer((_) async => Right(tEntry));
      // act
      final result = await useCase(tWord);
      // assert
      expect(result, Right(tEntry));
      verify(mockRepository.getWordDetailFromLocal(tWord));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return null when no entry found', () async {
      // arrange
      when(mockRepository.getWordDetailFromLocal(tWord))
          .thenAnswer((_) async => const Right(null));
      // act
      final result = await useCase(tWord);
      // assert
      expect(result, const Right(null));
      verify(mockRepository.getWordDetailFromLocal(tWord));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test get word detail from local', () {
    test('fail test should return failure when repository call fails', () async {
      // arrange
      when(mockRepository.getWordDetailFromLocal(tWord))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));
      // act
      final result = await useCase(tWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verify(mockRepository.getWordDetailFromLocal(tWord));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return failure when word is empty', () async {
      // arrange
      const emptyWord = '';
      // act
      final result = await useCase(emptyWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return failure when word is whitespace only', () async {
      // arrange
      const whitespaceWord = '   ';
      // act
      final result = await useCase(whitespaceWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verifyZeroInteractions(mockRepository);
    });
  });
} 