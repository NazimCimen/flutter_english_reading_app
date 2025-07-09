import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_remote_data_source.dart';
import 'package:english_reading_app/feature/saved_articles/data/repository/saved_articles_repository_impl.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_articles_repository_impl_test.mocks.dart';

@GenerateMocks([
  SavedArticlesRemoteDataSource,
  NetworkInfo,
])
void main() {
  late SavedArticlesRepositoryImpl repository;
  late MockSavedArticlesRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockSavedArticlesRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SavedArticlesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tArticles = [
    const ArticleModel(
      articleId: '1',
      title: 'Test Article 1',
      text: 'Test content 1',
    ),
    const ArticleModel(
      articleId: '2',
      title: 'Test Article 2',
      text: 'Test content 2',
    ),
  ];

  final tArticle = const ArticleModel(
    articleId: '1',
    title: 'Test Article',
    text: 'Test content',
  );

  const tArticleId = '1';
  final tArticleIds = <String>{'1', '2', '3'};

  group('success test get saved articles', () {
    test('success test should return articles when network is connected and remote data source is successful', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSavedArticles()).thenAnswer((_) async => tArticles);

      //act
      final result = await repository.getSavedArticles();

      //assert
      expect(result, Right(tArticles));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.getSavedArticles());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success test should return articles with limit and last document when provided', () async {
      //arrange
      const limit = 10;
      final lastDocument = MockDocumentSnapshot();
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSavedArticles(limit: limit, lastDocument: lastDocument))
          .thenAnswer((_) async => tArticles);

      //act
      final result = await repository.getSavedArticles(limit: limit, lastDocument: lastDocument);

      //assert
      expect(result, Right(tArticles));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.getSavedArticles(limit: limit, lastDocument: lastDocument));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test get saved articles', () {
    test('fail test should return connection failure when network is not connected', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);

      //act
      final result = await repository.getSavedArticles();

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verifyNever(mockRemoteDataSource.getSavedArticles());
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSavedArticles())
          .thenThrow(ServerException('Server error'));

      //act
      final result = await repository.getSavedArticles();

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.getSavedArticles());
    });

    test('fail test should return connection failure when remote data source throws connection exception', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSavedArticles())
          .thenThrow(ConnectionException('Connection error'));

      //act
      final result = await repository.getSavedArticles();

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.getSavedArticles());
    });
  });

  group('success test save article', () {
    test('success test should save article when network is connected and remote data source is successful', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.saveArticle(tArticle)).thenAnswer((_) async {});

      //act
      final result = await repository.saveArticle(tArticle);

      //assert
      expect(result, const Right(null));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.saveArticle(tArticle));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test save article', () {
    test('fail test should return connection failure when network is not connected', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);

      //act
      final result = await repository.saveArticle(tArticle);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verifyNever(mockRemoteDataSource.saveArticle(tArticle));
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.saveArticle(tArticle))
          .thenThrow(ServerException('Server error'));

      //act
      final result = await repository.saveArticle(tArticle);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.saveArticle(tArticle));
    });
  });

  group('success test remove article', () {
    test('success test should remove article when network is connected and remote data source is successful', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.removeArticle(tArticleId)).thenAnswer((_) async {});

      //act
      final result = await repository.removeArticle(tArticleId);

      //assert
      expect(result, const Right(null));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.removeArticle(tArticleId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test remove article', () {
    test('fail test should return connection failure when network is not connected', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);

      //act
      final result = await repository.removeArticle(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verifyNever(mockRemoteDataSource.removeArticle(tArticleId));
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.removeArticle(tArticleId))
          .thenThrow(ServerException('Server error'));

      //act
      final result = await repository.removeArticle(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.removeArticle(tArticleId));
    });
  });

  group('success test is article saved', () {
    test('success test should return true when article is saved', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.isArticleSaved(tArticleId)).thenAnswer((_) async => true);

      //act
      final result = await repository.isArticleSaved(tArticleId);

      //assert
      expect(result, const Right(true));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success test should return false when article is not saved', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.isArticleSaved(tArticleId)).thenAnswer((_) async => false);

      //act
      final result = await repository.isArticleSaved(tArticleId);

      //assert
      expect(result, const Right(false));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test is article saved', () {
    test('fail test should return connection failure when network is not connected', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);

      //act
      final result = await repository.isArticleSaved(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verifyNever(mockRemoteDataSource.isArticleSaved(tArticleId));
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.isArticleSaved(tArticleId))
          .thenThrow(ServerException('Server error'));

      //act
      final result = await repository.isArticleSaved(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.isArticleSaved(tArticleId));
    });
  });

  group('success test get saved article ids', () {
    test('success test should return article ids when network is connected and remote data source is successful', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSavedArticleIds()).thenAnswer((_) async => tArticleIds);

      //act
      final result = await repository.getSavedArticleIds();

      //assert
      expect(result, Right(tArticleIds));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.getSavedArticleIds());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test get saved article ids', () {
    test('fail test should return connection failure when network is not connected', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);

      //act
      final result = await repository.getSavedArticleIds();

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verifyNever(mockRemoteDataSource.getSavedArticleIds());
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      //arrange
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSavedArticleIds())
          .thenThrow(ServerException('Server error'));

      //act
      final result = await repository.getSavedArticleIds();

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.getSavedArticleIds());
    });
  });

  group('success test search saved articles', () {
    test('success test should return articles when network is connected and remote data source is successful', () async {
      //arrange
      const query = 'test';
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.searchSavedArticles(query)).thenAnswer((_) async => tArticles);

      //act
      final result = await repository.searchSavedArticles(query);

      //assert
      expect(result, Right(tArticles));
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.searchSavedArticles(query));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('fail test search saved articles', () {
    test('fail test should return connection failure when network is not connected', () async {
      //arrange
      const query = 'test';
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => false);

      //act
      final result = await repository.searchSavedArticles(query);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verifyNever(mockRemoteDataSource.searchSavedArticles(query));
    });

    test('fail test should return server failure when remote data source throws server exception', () async {
      //arrange
      const query = 'test';
      when(mockNetworkInfo.currentConnectivityResult).thenAnswer((_) async => true);
      when(mockRemoteDataSource.searchSavedArticles(query))
          .thenThrow(ServerException('Server error'));

      //act
      final result = await repository.searchSavedArticles(query);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockNetworkInfo.currentConnectivityResult);
      verify(mockRemoteDataSource.searchSavedArticles(query));
    });
  });
}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {} 