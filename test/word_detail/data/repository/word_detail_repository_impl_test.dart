// ignore_for_file: inference_failure_on_instance_creation
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

import 'word_detail_repository_impl_test.mocks.dart';

@GenerateMocks([
  WordDetailRemoteDataSource,
  NetworkInfo,
])
void main() {
  late WordDetailRepositoryImpl repository;
  late MockWordDetailRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockWordDetailRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WordDetailRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tWord = 'test';
  const tUserId = 'userId';
  final tEntries = [
    DictionaryEntry(word: tWord, meanings: [], phonetics: []),
  ];
  final tEntry = DictionaryEntry(word: tWord, meanings: [], phonetics: []);
  const tDocId = 'docId';

  group('success test get word detail from api', () {
    test('success test should return entry when remote data source call is successful', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWordDetail(tWord))
          .thenAnswer((_) async => tEntries);
      // act
      final result = await repository.getWordDetailFromApi(tWord);
      // assert
      expect(result, Right(tEntry));
      verify(mockRemoteDataSource.getWordDetail(tWord));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success test should return null when no entries found', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWordDetail(tWord))
          .thenAnswer((_) async => <DictionaryEntry>[]);
      // act
      final result = await repository.getWordDetailFromApi(tWord);
      // assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.getWordDetail(tWord));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test get word detail from api', () {
    test('fail test should return connection failure when no internet', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);
      // act
      final result = await repository.getWordDetailFromApi(tWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWordDetail(tWord))
          .thenThrow(ServerException('Server error'));
      // act
      final result = await repository.getWordDetailFromApi(tWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verify(mockRemoteDataSource.getWordDetail(tWord));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('fail test should return connection failure when remote data source throws connection exception', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWordDetail(tWord))
          .thenThrow(ConnectionException('Connection error'));
      // act
      final result = await repository.getWordDetailFromApi(tWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verify(mockRemoteDataSource.getWordDetail(tWord));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('success test get word detail from local', () {
    test('success test should return entry when remote data source call is successful', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWordDetailFromFirestore(tWord))
          .thenAnswer((_) async => tEntry);
      // act
      final result = await repository.getWordDetailFromLocal(tWord);
      // assert
      expect(result, Right(tEntry));
      verify(mockRemoteDataSource.getWordDetailFromFirestore(tWord));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success test should return null when no entry found', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWordDetailFromFirestore(tWord))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.getWordDetailFromLocal(tWord);
      // assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.getWordDetailFromFirestore(tWord));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test get word detail from local', () {
    test('fail test should return connection failure when no internet', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);
      // act
      final result = await repository.getWordDetailFromLocal(tWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWordDetailFromFirestore(tWord))
          .thenThrow(ServerException('Server error'));
      // act
      final result = await repository.getWordDetailFromLocal(tWord);
      // assert
      expect(result, isA<Left<Failure, DictionaryEntry?>>());
      verify(mockRemoteDataSource.getWordDetailFromFirestore(tWord));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('success test save word to local', () {
    test('success test should return docId when remote data source call is successful', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.saveWordToFirestore(tEntry))
          .thenAnswer((_) async => tDocId);
      // act
      final result = await repository.saveWordToLocal(tEntry);
      // assert
      expect(result, Right(tDocId));
      verify(mockRemoteDataSource.saveWordToFirestore(tEntry));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test save word to local', () {
    test('fail test should return connection failure when no internet', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);
      // act
      final result = await repository.saveWordToLocal(tEntry);
      // assert
      expect(result, isA<Left<Failure, String>>());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.saveWordToFirestore(tEntry))
          .thenThrow(ServerException('Server error'));
      // act
      final result = await repository.saveWordToLocal(tEntry);
      // assert
      expect(result, isA<Left<Failure, String>>());
      verify(mockRemoteDataSource.saveWordToFirestore(tEntry));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('success test is word saved', () {
    test('success test should return true when word is saved', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.isWordSavedInFirestore(tWord, tUserId))
          .thenAnswer((_) async => true);
      // act
      final result = await repository.isWordSaved(tWord, tUserId);
      // assert
      expect(result, const Right(true));
      verify(mockRemoteDataSource.isWordSavedInFirestore(tWord, tUserId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success test should return false when word is not saved', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.isWordSavedInFirestore(tWord, tUserId))
          .thenAnswer((_) async => false);
      // act
      final result = await repository.isWordSaved(tWord, tUserId);
      // assert
      expect(result, const Right(false));
      verify(mockRemoteDataSource.isWordSavedInFirestore(tWord, tUserId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test is word saved', () {
    test('fail test should return connection failure when no internet', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);
      // act
      final result = await repository.isWordSaved(tWord, tUserId);
      // assert
      expect(result, isA<Left<Failure, bool>>());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      // arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.isWordSavedInFirestore(tWord, tUserId))
          .thenThrow(ServerException('Server error'));
      // act
      final result = await repository.isWordSaved(tWord, tUserId);
      // assert
      expect(result, isA<Left<Failure, bool>>());
      verify(mockRemoteDataSource.isWordSavedInFirestore(tWord, tUserId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
} 