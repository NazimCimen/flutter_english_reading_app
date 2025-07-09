import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/add_word_to_bank_usecase.dart';

import 'add_word_to_bank_usecase_test.mocks.dart';

@GenerateMocks([WordBankRepository])
void main() {
  late AddWordToBankUseCase useCase;
  late MockWordBankRepository mockRepository;

  setUp(() {
    mockRepository = MockWordBankRepository();
    useCase = AddWordToBankUseCase(repository: mockRepository);
  });

  group('success/fail test AddWordToBankUseCase', () {
    test('success test should return document ID when repository call is successful', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [Meaning(partOfSpeech: 'noun', definitions: [Definition(definition: 'A test')])]);
      when(mockRepository.addWord(any)).thenAnswer((_) async => Right('doc123'));
      //act
      final result = await useCase(tWord);
      //assert
      expect(result, Right('doc123'));
      verify(mockRepository.addWord(any));
    });

    test('fail test should return InputNoImageFailure when word is empty', () async {
      //arrange
      final tWord = DictionaryEntry(word: '', meanings: [Meaning(partOfSpeech: 'noun', definitions: [Definition(definition: 'A test')])]);
      //act
      final result = await useCase(tWord);
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return InputNoImageFailure when meanings is empty', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [Meaning(partOfSpeech: '', definitions: [Definition(definition: 'A test')])]);
      //act
      final result = await useCase(tWord);
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return InputNoImageFailure when partOfSpeech is empty', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [Meaning(partOfSpeech: '', definitions: [Definition(definition: 'A test')])]);
      //act
      final result = await useCase(tWord);
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return InputNoImageFailure when definitions is empty', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [Meaning(partOfSpeech: 'noun', definitions: [])]);
      //act
      final result = await useCase(tWord);
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return InputNoImageFailure when definition is empty', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [Meaning(partOfSpeech: 'noun', definitions: [Definition(definition: '')])]);
      //act
      final result = await useCase(tWord);
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<InputNoImageFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return ServerFailure when repository call fails', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [Meaning(partOfSpeech: 'noun', definitions: [Definition(definition: 'A test')])]);
      when(mockRepository.addWord(any)).thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Add failed')));
      //act
      final result = await useCase(tWord);
      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.addWord(any));
    });
  });
} 