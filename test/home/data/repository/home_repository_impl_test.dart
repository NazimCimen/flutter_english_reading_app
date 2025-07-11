// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:english_reading_app/feature/home/data/repository/home_repository_impl.dart';
import 'package:english_reading_app/product/model/article_model.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([
  HomeRemoteDataSource,
])
void main() {
  late HomeRepositoryImpl repository;
  late MockHomeRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('success/fail test getArticles', () {
    final testArticles = [
      const ArticleModel(
        title: 'Test Article 1',
        text: 'Test content 1',
        category: 'tech',
        imageUrl: 'https://test.com/image1.jpg',
        articleId: 'test_id_1',
      ),
      const ArticleModel(
        title: 'Test Article 2',
        text: 'Test content 2',
        category: 'science',
        imageUrl: 'https://test.com/image2.jpg',
        articleId: 'test_id_2',
      ),
    ];

    test('success test should return Right with articles when data source call is successful', () async {
      //arrange
      when(mockRemoteDataSource.getArticles(
        
      )).thenAnswer((_) async => testArticles);

      //act
      final result = await repository.getArticles();

      //assert
      expect(result, Right<Failure, List<ArticleModel>>(testArticles));
      verify(mockRemoteDataSource.getArticles(
        
      ));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success test should return Right with articles when category filter is applied', () async {
      //arrange
      when(mockRemoteDataSource.getArticles(
        categoryFilter: 'tech',
        limit: 10,
        reset: true,
      )).thenAnswer((_) async => [testArticles.first]);

      //act
      final result = await repository.getArticles(
        categoryFilter: 'tech',
        reset: true,
      );

      //assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not reach here'),
        (articles) {
          expect(articles, [testArticles.first]);
          expect(articles.length, 1);
          expect(articles.first.title, 'Test Article 1');
        },
      );
      verify(mockRemoteDataSource.getArticles(
        categoryFilter: 'tech',
        limit: 10,
        reset: true,
      ));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success test should return Right with empty list when no articles found', () async {
      //arrange
      when(mockRemoteDataSource.getArticles(
        
      )).thenAnswer((_) async => []);

      //act
      final result = await repository.getArticles();

      //assert
      // ignore: inference_failure_on_collection_literal
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not reach here'),
        (articles) {
          expect(articles, isEmpty);
          expect(articles.length, 0);
        },
      );
      verify(mockRemoteDataSource.getArticles(
        
      ));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('fail test should return Left with ServerFailure when ServerException is thrown', () async {
      //arrange
      when(mockRemoteDataSource.getArticles(
        
      )).thenThrow(ServerException('Server connection failed'));

      //act
      final result = await repository.getArticles();

      //assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.errorMessage, 'Server connection failed');
        },
        (_) => fail('Should not reach here'),
      );
      verify(mockRemoteDataSource.getArticles(
        
      ));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('fail test should return Left with ConnectionFailure when ConnectionException is thrown', () async {
      //arrange
      when(mockRemoteDataSource.getArticles(
        
      )).thenThrow(ConnectionException('No internet connection'));

      //act
      final result = await repository.getArticles();

      //assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect(failure.errorMessage, 'No internet connection');
        },
        (_) => fail('Should not reach here'),
      );
    });

    test('fail test should return Left with UnKnownFaliure when UnKnownException is thrown', () async {
      //arrange
      when(mockRemoteDataSource.getArticles(
        
      )).thenThrow(UnKnownException('Unknown error occurred'));

      //act
      final result = await repository.getArticles();

      //assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnKnownFaliure>());
          expect(failure.errorMessage, 'Unknown error occurred');
        },
        (_) => fail('Should not reach here'),
      );
    });

    test('fail test should return Left with UnKnownFaliure when unexpected exception is thrown', () async {
      //arrange
      when(mockRemoteDataSource.getArticles(
        
      )).thenThrow(Exception('Unexpected error'));

      //act
      final result = await repository.getArticles();

      //assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnKnownFaliure>());
          expect(failure.errorMessage, contains('Exception: Unexpected error'));
        },
        (_) => fail('Should not reach here'),
      );
    });
  });

  group('success/fail test resetPagination', () {
    test('success test should call resetPagination on data source', () {
      //arrange
      when(mockRemoteDataSource.resetPagination()).thenReturn(null);

      //act
      repository.resetPagination();

      //assert
      verify(mockRemoteDataSource.resetPagination());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
} 