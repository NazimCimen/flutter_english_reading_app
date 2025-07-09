import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_api_usecase.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_word_detail_from_api_usecase_test.mocks.dart';

@GenerateMocks([WordDetailRepository])
void main() {
  late GetWordDetailFromApiUseCase useCase;
  late MockWordDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockWordDetailRepository();
    useCase = GetWordDetailFromApiUseCase(mockRepository);
  });

  final tWord = 'test';
  final tDictionaryEntry = DictionaryEntry(
    word: 'test',
    meanings: [],
    phonetics: [],
  );

  group('success test get word detail from api', () {
    test('success test should return dictionary entry when repository call is successful', () async {
      //arrange
      when(mockRepository.getWordDetailFromApi(tWord))
          .thenAnswer((_) async => Right(tDictionaryEntry));

      //act
      final result = await useCase(tWord);

      //assert
      expect(result, Right(tDictionaryEntry));
      verify(mockRepository.getWordDetailFromApi(tWord));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test get word detail from api', () {
    test('fail test should return failure when word is empty', () async {
      //arrange
      const emptyWord = '';

      //act
      final result = await useCase(emptyWord);

      //assert
      expect(result, isA<Left<UnKnownFaliure, DictionaryEntry?>>());
      verifyNever(mockRepository.getWordDetailFromApi(any));
    });

    test('fail test should return failure when word is whitespace only', () async {
      //arrange
      const whitespaceWord = '   ';

      //act
      final result = await useCase(whitespaceWord);

      //assert
      expect(result, isA<Left<UnKnownFaliure, DictionaryEntry?>>());
      verifyNever(mockRepository.getWordDetailFromApi(any));
    });

    test('fail test should return failure when repository returns failure', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.getWordDetailFromApi(tWord))
          .thenAnswer((_) async => Left(failure));

      //act
      final result = await useCase(tWord);

      //assert
      expect(result, Left(failure));
      verify(mockRepository.getWordDetailFromApi(tWord));
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 