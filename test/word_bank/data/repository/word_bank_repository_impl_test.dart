import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_local_data_source.dart';
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_remote_data_source.dart';
import 'package:english_reading_app/feature/word_bank/data/repository/word_bank_repository_impl.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/services/user_service.dart';

import 'word_bank_repository_impl_test.mocks.dart';

@GenerateMocks([
  WordBankRemoteDataSource,
  WordBankLocalDataSource,
  NetworkInfo,
  UserService,
])
void main() {
  late WordBankRepositoryImpl repository;
  late MockWordBankRemoteDataSource mockRemoteDataSource;
  late MockWordBankLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockUserService mockUserService;

  setUp(() {
    mockRemoteDataSource = MockWordBankRemoteDataSource();
    mockLocalDataSource = MockWordBankLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockUserService = MockUserService();
    repository = WordBankRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
      userService: mockUserService,
    );
  });

  group('success/fail test getWords', () {
    test('success test should return words from remote when connected', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn('user1');
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      final tWords = [DictionaryEntry(word: 'test', meanings: [])];
      when(mockRemoteDataSource.getWords(userId: 'user1', reset: false, limit: 10)).thenAnswer((_) async => tWords);
      // act
      final result = await repository.getWords();
      // assert
      expect(result, Right(tWords));
      verify(mockRemoteDataSource.getWords(userId: 'user1', reset: false, limit: 10));
    });

    test('fail test should return ServerFailure if user is not authenticated', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn(null);
      // act
      final result = await repository.getWords();
      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });

    test('fail test should return ConnectionFailure if not connected', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn('user1');
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);
      // act
      final result = await repository.getWords();
      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
    });

    test('fail test should return ServerFailure on ServerException', () async {
      // arrange
      when(mockUserService.getUserId()).thenReturn('user1');
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getWords(userId: 'user1', reset: false, limit: 10)).thenThrow(ServerException('error'));
      // act
      final result = await repository.getWords();
      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  // Diğer metotlar için benzer şekilde success/fail test grupları eklenebilir.
} 