// ignore_for_file: inference_failure_on_instance_creation
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

import 'word_detail_remote_data_source_test.mocks.dart';

@GenerateMocks([
  Dio,
  BaseFirebaseService,
])
void main() {
  late WordDetailRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockBaseFirebaseService<DictionaryEntry> mockFirebaseService;

  setUp(() {
    mockDio = MockDio();
    mockFirebaseService = MockBaseFirebaseService<DictionaryEntry>();
    dataSource = WordDetailRemoteDataSourceImpl(mockDio, mockFirebaseService);
  });

  const tWord = 'test';
  const tUserId = 'userId';
  final tEntries = [
    DictionaryEntry(word: tWord, meanings: [], phonetics: []),
  ];
  final tEntry = DictionaryEntry(word: tWord, meanings: [], phonetics: []);
  const tDocId = 'docId';

  group('success test get word detail', () {
    test('success test should return entries when dio call is successful', () async {
      // arrange
      final response = Response<List<dynamic>>(
        data: [
          {
            'word': tWord,
            'meanings': [],
            'phonetics': [],
          }
        ],
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );
      when(mockDio.get<List<dynamic>>(any))
          .thenAnswer((_) async => response);
      // act
      final result = await dataSource.getWordDetail(tWord);
      // assert
      expect(result, isA<List<DictionaryEntry>>());
      expect(result.length, 1);
      expect(result.first.word, tWord);
      verify(mockDio.get<List<dynamic>>(any));
      verifyNoMoreInteractions(mockDio);
    });
  });

  group('fail test get word detail', () {
    test('fail test should throw server exception when status code is not 200', () async {
      // arrange
      final response = Response<List<dynamic>>(
        data: null,
        statusCode: 404,
        requestOptions: RequestOptions(path: ''),
      );
      when(mockDio.get<List<dynamic>>(any))
          .thenAnswer((_) async => response);
      // act & assert
      expect(
        () => dataSource.getWordDetail(tWord),
        throwsA(isA<UnKnownException>()),
      );
      verify(mockDio.get<List<dynamic>>(any));
      verifyNoMoreInteractions(mockDio);
    });

    test('fail test should throw server exception when timeout occurs', () async {
      // arrange
      when(mockDio.get<List<dynamic>>(any))
          .thenThrow(TimeoutException('timeout', const Duration(seconds: 5)));
      // act & assert
      expect(
        () => dataSource.getWordDetail(tWord),
        throwsA(isA<ServerException>()),
      );
      verify(mockDio.get<List<dynamic>>(any));
      verifyNoMoreInteractions(mockDio);
    });

    test('fail test should throw server exception when dio exception occurs', () async {
      // arrange
      when(mockDio.get<List<dynamic>>(any))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Network error',
          ));
      // act & assert
      expect(
        () => dataSource.getWordDetail(tWord),
        throwsA(isA<ServerException>()),
      );
      verify(mockDio.get<List<dynamic>>(any));
      verifyNoMoreInteractions(mockDio);
    });
  });

  group('success test get word detail from firestore', () {
    test('success test should return entry when firebase service call is successful', () async {
      // arrange
      when(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      )).thenAnswer((_) async => tEntries);
      // act
      final result = await dataSource.getWordDetailFromFirestore(tWord);
      // assert
      expect(result, tEntry);
      verify(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      ));
      verifyNoMoreInteractions(mockFirebaseService);
    });

    test('success test should return null when no entries found', () async {
      // arrange
      when(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      )).thenAnswer((_) async => <DictionaryEntry>[]);
      // act
      final result = await dataSource.getWordDetailFromFirestore(tWord);
      // assert
      expect(result, null);
      verify(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      ));
      verifyNoMoreInteractions(mockFirebaseService);
    });
  });

  group('fail test get word detail from firestore', () {
    test('fail test should throw server exception when firebase service throws exception', () async {
      // arrange
      when(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      )).thenThrow(Exception('Firebase error'));
      // act & assert
      expect(
        () => dataSource.getWordDetailFromFirestore(tWord),
        throwsA(isA<ServerException>()),
      );
      verify(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      ));
      verifyNoMoreInteractions(mockFirebaseService);
    });
  });

  group('success test save word to firestore', () {
    test('success test should return docId when firebase service call is successful', () async {
      // arrange
      when(mockFirebaseService.addItem(any, any))
          .thenAnswer((_) async => tDocId);
      // act
      final result = await dataSource.saveWordToFirestore(tEntry);
      // assert
      expect(result, tDocId);
      verify(mockFirebaseService.addItem(any, any));
      verifyNoMoreInteractions(mockFirebaseService);
    });
  });

  group('fail test save word to firestore', () {
    test('fail test should throw server exception when firebase service throws exception', () async {
      // arrange
      when(mockFirebaseService.addItem(any, any))
          .thenThrow(Exception('Firebase error'));
      // act & assert
      expect(
        () => dataSource.saveWordToFirestore(tEntry),
        throwsA(isA<ServerException>()),
      );
      verify(mockFirebaseService.addItem(any, any));
      verifyNoMoreInteractions(mockFirebaseService);
    });
  });

  group('success test is word saved in firestore', () {
    test('success test should return true when word is saved', () async {
      // arrange
      when(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      )).thenAnswer((_) async => tEntries);
      // act
      final result = await dataSource.isWordSavedInFirestore(tWord, tUserId);
      // assert
      expect(result, true);
      verify(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      ));
      verifyNoMoreInteractions(mockFirebaseService);
    });

    test('success test should return false when word is not saved', () async {
      // arrange
      when(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      )).thenAnswer((_) async => <DictionaryEntry>[]);
      // act
      final result = await dataSource.isWordSavedInFirestore(tWord, tUserId);
      // assert
      expect(result, false);
      verify(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      ));
      verifyNoMoreInteractions(mockFirebaseService);
    });
  });

  group('fail test is word saved in firestore', () {
    test('fail test should throw server exception when firebase service throws exception', () async {
      // arrange
      when(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      )).thenThrow(Exception('Firebase error'));
      // act & assert
      expect(
        () => dataSource.isWordSavedInFirestore(tWord, tUserId),
        throwsA(isA<ServerException>()),
      );
      verify(mockFirebaseService.queryItems(
        collectionPath: anyNamed('collectionPath'),
        conditions: anyNamed('conditions'),
        model: anyNamed('model'),
      ));
      verifyNoMoreInteractions(mockFirebaseService);
    });
  });
} 