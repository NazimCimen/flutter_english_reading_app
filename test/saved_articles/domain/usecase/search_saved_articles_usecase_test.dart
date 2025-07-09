import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/search_saved_articles_usecase.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_saved_articles_usecase_test.mocks.dart';

@GenerateMocks([SavedArticlesRepository])
void main() {
  late SearchSavedArticlesUseCase useCase;
  late MockSavedArticlesRepository mockRepository;

  setUp(() {
    mockRepository = MockSavedArticlesRepository();
    useCase = SearchSavedArticlesUseCase(mockRepository);
  });

  const tQuery = 'test';
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

  group('success test search saved articles', () {
    test('success test should return articles when repository call is successful', () async {
      //arrange
      when(mockRepository.searchSavedArticles(tQuery))
          .thenAnswer((_) async => Right(tArticles));

      //act
      final result = await useCase(tQuery);

      //assert
      expect(result, Right(tArticles));
      verify(mockRepository.searchSavedArticles(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return empty list when no articles found', () async {
      //arrange
      when(mockRepository.searchSavedArticles(tQuery))
          .thenAnswer((_) async => const Right([]));

      //act
      final result = await useCase(tQuery);

      //assert
      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r), isEmpty);
      verify(mockRepository.searchSavedArticles(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test search saved articles', () {
    test('fail test should return server failure when repository call fails', () async {
      //arrange
      when(mockRepository.searchSavedArticles(tQuery))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await useCase(tQuery);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.searchSavedArticles(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.searchSavedArticles(tQuery))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await useCase(tQuery);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockRepository.searchSavedArticles(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 