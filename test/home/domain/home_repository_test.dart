import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/home/domain/repository/home_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

import 'home_repository_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
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

    test('success test should return Right with articles when repository call is successful', () async {
      //arrange
      when(mockRepository.getArticles()).thenAnswer((_) async => Right(testArticles));

      //act
      final result = await mockRepository.getArticles();

      //assert
      // ignore: inference_failure_on_instance_creation
      expect(result, Right<Failure, List<ArticleModel>>(testArticles));
      verify(mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return Right with filtered articles when category filter is provided', () async {
      //arrange
      when(mockRepository.getArticles(categoryFilter: 'tech', reset: true))
          .thenAnswer((_) async => Right([testArticles.first]));

      //act
      final result = await mockRepository.getArticles(categoryFilter: 'tech', reset: true);

      //assert
      // ignore: inference_failure_on_instance_creation
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not reach here'),
        (articles) {
          expect(articles, [testArticles.first]);
          expect(articles.length, 1);
          expect(articles.first.title, 'Test Article 1');
        },
      );
      verify(mockRepository.getArticles(categoryFilter: 'tech', reset: true));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return Right with empty list when no articles found', () async {
      //arrange
      when(mockRepository.getArticles()).thenAnswer((_) async => const Right([]));

      //act
      final result = await mockRepository.getArticles();

      //assert
      // ignore: inference_failure_on_instance_creation
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not reach here'),
        (articles) {
          expect(articles, isEmpty);
          expect(articles.length, 0);
        },
      );
      verify(mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return Left with ServerFailure when server error occurs', () async {
      //arrange
      when(mockRepository.getArticles())
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await mockRepository.getArticles();

      //assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.errorMessage, 'Server error');
        },
        (_) => fail('Should not reach here'),
      );
      verify(mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return Left with ConnectionFailure when connection error occurs', () async {
      //arrange
      when(mockRepository.getArticles())
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await mockRepository.getArticles();

      //assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect(failure.errorMessage, 'Connection error');
        },
        (_) => fail('Should not reach here'),
      );
      verify(mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return Left with UnKnownFaliure when unknown error occurs', () async {
      //arrange
      when(mockRepository.getArticles())
          .thenAnswer((_) async => Left(UnKnownFaliure(errorMessage: 'Unknown error')));

      //act
      final result = await mockRepository.getArticles();

      //assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnKnownFaliure>());
          expect(failure.errorMessage, 'Unknown error');
        },
        (_) => fail('Should not reach here'),
      );
      verify(mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success/fail test resetPagination', () {
    test('success test should call resetPagination method', () {
      //arrange
      when(mockRepository.resetPagination()).thenReturn(null);

      //act
      mockRepository.resetPagination();

      //assert
      verify(mockRepository.resetPagination());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success/fail test method signatures', () {
    test('success test should have correct getArticles method signature', () {
      //arrange
      //act
      //assert
      expect(mockRepository.getArticles, isA<Function>());
    });

    test('success test should have correct resetPagination method signature', () {
      //arrange
      //act
      //assert
      expect(mockRepository.resetPagination, isA<Function>());
    });
  });
} 