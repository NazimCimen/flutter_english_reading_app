import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_remote_data_source.dart';

import 'word_bank_remote_data_source_test.mocks.dart';

@GenerateMocks([
  BaseFirebaseService,
])
void main() {
  late WordBankRemoteDataSourceImpl dataSource;
  late MockBaseFirebaseService<DictionaryEntry> mockFirebaseService;

  setUp(() {
    mockFirebaseService = MockBaseFirebaseService<DictionaryEntry>();
    dataSource = WordBankRemoteDataSourceImpl(
      firebaseService: mockFirebaseService,
    );
  });

  group('success/fail test addWord', () {
    test('success test should return document ID when word is added successfully', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: []);
      when(mockFirebaseService.addItem('dictionary', tWord))
          .thenAnswer((_) async => 'doc123');
      //act
      final result = await dataSource.addWord(tWord);
      //assert
      expect(result, 'doc123');
      verify(mockFirebaseService.addItem('dictionary', tWord));
    });

    test('fail test should throw ServerException on timeout', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: []);
      when(mockFirebaseService.addItem('dictionary', tWord))
          .thenThrow(TimeoutException('Request timeout'));
      //act & assert
      expect(
        () => dataSource.addWord(tWord),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw ServerException on general error', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: []);
      when(mockFirebaseService.addItem('dictionary', tWord))
          .thenThrow(Exception('General error'));
      //act & assert
      expect(
        () => dataSource.addWord(tWord),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('success/fail test updateWord', () {
    test('success test should update word successfully', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [], documentId: 'doc123');
      when(mockFirebaseService.updateItem('dictionary', 'doc123', tWord))
          .thenAnswer((_) async {});
      //act
      await dataSource.updateWord(tWord);
      //assert
      verify(mockFirebaseService.updateItem('dictionary', 'doc123', tWord));
    });

    test('fail test should throw ServerException on timeout', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [], documentId: 'doc123');
      when(mockFirebaseService.updateItem('dictionary', 'doc123', tWord))
          .thenThrow(TimeoutException('Request timeout'));
      //act & assert
      expect(
        () => dataSource.updateWord(tWord),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw ServerException on general error', () async {
      //arrange
      final tWord = DictionaryEntry(word: 'test', meanings: [], documentId: 'doc123');
      when(mockFirebaseService.updateItem('dictionary', 'doc123', tWord))
          .thenThrow(Exception('General error'));
      //act & assert
      expect(
        () => dataSource.updateWord(tWord),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('success/fail test deleteWord', () {
    test('success test should delete word successfully', () async {
      //arrange
      when(mockFirebaseService.deleteItem('dictionary', 'doc123'))
          .thenAnswer((_) async {});
      //act
      await dataSource.deleteWord('doc123');
      //assert
      verify(mockFirebaseService.deleteItem('dictionary', 'doc123'));
    });

    test('fail test should throw ServerException on timeout', () async {
      //arrange
      when(mockFirebaseService.deleteItem('dictionary', 'doc123'))
          .thenThrow(TimeoutException('Request timeout'));
      //act & assert
      expect(
        () => dataSource.deleteWord('doc123'),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw ServerException on general error', () async {
      //arrange
      when(mockFirebaseService.deleteItem('dictionary', 'doc123'))
          .thenThrow(Exception('General error'));
      //act & assert
      expect(
        () => dataSource.deleteWord('doc123'),
        throwsA(isA<ServerException>()),
      );
    });
  });
} 