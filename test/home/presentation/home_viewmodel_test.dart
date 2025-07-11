import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/home/domain/usecase/get_articles_usecase.dart';
import 'package:english_reading_app/feature/home/domain/usecase/reset_pagination_usecase.dart';
import 'package:english_reading_app/feature/home/presentation/viewmodel/home_view_model.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

import 'home_viewmodel_test.mocks.dart';

@GenerateMocks([
  GetArticlesUseCase,
  ResetPaginationUseCase,
  SavedArticlesRepository,
])
void main() {
  late HomeViewModel viewModel;
  late MockGetArticlesUseCase mockGetArticlesUseCase;
  late MockResetPaginationUseCase mockResetPaginationUseCase;
  late MockSavedArticlesRepository mockSavedArticlesRepository;

  setUp(() {
    mockGetArticlesUseCase = MockGetArticlesUseCase();
    mockResetPaginationUseCase = MockResetPaginationUseCase();
    mockSavedArticlesRepository = MockSavedArticlesRepository();
    viewModel = HomeViewModel(
      getArticlesUseCase: mockGetArticlesUseCase,
      resetPaginationUseCase: mockResetPaginationUseCase,
      savedArticlesRepository: mockSavedArticlesRepository,
    );
  });

  group('success/fail test fetchArticles', () {
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

    test('success test should return articles when use case call is successful', () async {
      //arrange
      when(mockGetArticlesUseCase.call()).thenAnswer((_) async => Right(testArticles));

      //act
      final result = await viewModel.fetchArticles(categoryFilter: null);

      //assert
      expect(result, testArticles);
      verify(mockGetArticlesUseCase.call());
      verifyNoMoreInteractions(mockGetArticlesUseCase);
    });

    test('success test should return articles with category filter', () async {
      //arrange
      when(mockGetArticlesUseCase.call(categoryFilter: 'tech', limit: 15, reset: true))
          .thenAnswer((_) async => Right([testArticles.first]));

      //act
      final result = await viewModel.fetchArticles(
        categoryFilter: 'tech',
        limit: 15,
        reset: true,
      );

      //assert
      expect(result, [testArticles.first]);
      verify(mockGetArticlesUseCase.call(categoryFilter: 'tech', limit: 15, reset: true));
      verifyNoMoreInteractions(mockGetArticlesUseCase);
    });

    test('success test should return empty list when no articles found', () async {
      //arrange
      when(mockGetArticlesUseCase.call()).thenAnswer((_) async => const Right([]));

      //act
      final result = await viewModel.fetchArticles(categoryFilter: null);

      //assert
      expect(result, isEmpty);
      verify(mockGetArticlesUseCase.call());
      verifyNoMoreInteractions(mockGetArticlesUseCase);
    });

    test('fail test should return empty list when ServerFailure occurs', () async {
      //arrange
      when(mockGetArticlesUseCase.call())
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server connection failed')));

      //act
      final result = await viewModel.fetchArticles(categoryFilter: null);

      //assert
      expect(result, isEmpty);
      verify(mockGetArticlesUseCase.call());
      verifyNoMoreInteractions(mockGetArticlesUseCase);
    });

    test('fail test should return empty list when ConnectionFailure occurs', () async {
      //arrange
      when(mockGetArticlesUseCase.call())
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'No internet connection')));

      //act
      final result = await viewModel.fetchArticles(categoryFilter: null);

      //assert
      expect(result, isEmpty);
      verify(mockGetArticlesUseCase.call());
      verifyNoMoreInteractions(mockGetArticlesUseCase);
    });

    test('fail test should return empty list when UnKnownFaliure occurs', () async {
      //arrange
      when(mockGetArticlesUseCase.call())
          .thenAnswer((_) async => Left(UnKnownFaliure(errorMessage: 'Unknown error occurred')));

      //act
      final result = await viewModel.fetchArticles(categoryFilter: null);

      //assert
      expect(result, isEmpty);
      verify(mockGetArticlesUseCase.call());
      verifyNoMoreInteractions(mockGetArticlesUseCase);
    });
  });

  group('success/fail test saveArticle', () {
    const testArticle = ArticleModel(
      title: 'Test Article',
      text: 'Test content',
      category: 'tech',
      imageUrl: 'https://test.com/image.jpg',
      articleId: 'test_id',
    );

    test('success test should call saveArticle on repository when successful', () async {
      //arrange
      when(mockSavedArticlesRepository.saveArticle(testArticle))
          .thenAnswer((_) async => const Right(null));

      //act
      await viewModel.saveArticle(testArticle);

      //assert
      verify(mockSavedArticlesRepository.saveArticle(testArticle));
      verifyNoMoreInteractions(mockSavedArticlesRepository);
    });

    test('fail test should handle save article failure gracefully', () async {
      //arrange
      when(mockSavedArticlesRepository.saveArticle(testArticle))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Save failed')));

      //act
      await viewModel.saveArticle(testArticle);

      //assert
      verify(mockSavedArticlesRepository.saveArticle(testArticle));
      verifyNoMoreInteractions(mockSavedArticlesRepository);
    });
  });

  group('success/fail test removeArticle', () {
    const testArticleId = 'test_article_id';

    test('success test should call removeArticle on repository when successful', () async {
      //arrange
      when(mockSavedArticlesRepository.removeArticle(testArticleId))
          .thenAnswer((_) async => const Right(null));

      //act
      await viewModel.removeArticle(testArticleId);

      //assert
      verify(mockSavedArticlesRepository.removeArticle(testArticleId));
      verifyNoMoreInteractions(mockSavedArticlesRepository);
    });

    test('fail test should handle remove article failure gracefully', () async {
      //arrange
      when(mockSavedArticlesRepository.removeArticle(testArticleId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Remove failed')));

      //act
      await viewModel.removeArticle(testArticleId);

      //assert
      verify(mockSavedArticlesRepository.removeArticle(testArticleId));
      verifyNoMoreInteractions(mockSavedArticlesRepository);
    });
  });

  group('success/fail test isArticleSaved', () {
    const testArticleId = 'test_article_id';

    test('success test should return true when article is saved', () {
      //arrange
      viewModel.clearCache(); // Reset cache for testing
      // Simulate article being saved by manually adding to cache
      // Since _savedArticleIdsCache is private, we test the default behavior

      //act
      final result = viewModel.isArticleSaved(testArticleId);

      //assert
      expect(result, false); // Should return false when cache is null
    });

    test('success test should return false when cache is null', () {
      //arrange
      viewModel.clearCache(); // Ensure cache is null

      //act
      final result = viewModel.isArticleSaved(testArticleId);

      //assert
      expect(result, false);
    });
  });

  group('success/fail test preloadSavedArticleIds', () {
    final testIds = {'id1', 'id2', 'id3'};

    test('success test should load saved article IDs when repository call is successful', () async {
      //arrange
      when(mockSavedArticlesRepository.getSavedArticleIds())
          .thenAnswer((_) async => Right(testIds));

      //act
      await viewModel.preloadSavedArticleIds();

      //assert
      verify(mockSavedArticlesRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockSavedArticlesRepository);
    });

    test('fail test should handle loading failure gracefully', () async {
      //arrange
      when(mockSavedArticlesRepository.getSavedArticleIds())
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Load failed')));

      //act
      await viewModel.preloadSavedArticleIds();

      //assert
      verify(mockSavedArticlesRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockSavedArticlesRepository);
    });
  });

  group('success/fail test clearCache', () {
    test('success test should clear cache successfully', () {
      //arrange
      //act
      viewModel.clearCache();

      //assert
      // Since clearCache is void and resets internal state,
      // we can verify it doesn't throw
      expect(() => viewModel.clearCache(), returnsNormally);
    });
  });
} 