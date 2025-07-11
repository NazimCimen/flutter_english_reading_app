import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_articles_view_model_test.mocks.dart';

@GenerateMocks([
  SavedArticlesRepository,
])
void main() {
  late SavedArticlesViewModel viewModel;
  late MockSavedArticlesRepository mockRepository;

  setUp(() {
    mockRepository = MockSavedArticlesRepository();
    viewModel = SavedArticlesViewModel(
      repository: mockRepository,
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

  const tArticleId = '1';

  group('success test fetch saved articles', () {
    test('success test should fetch articles when repository call is successful', () async {
      //arrange
      when(mockRepository.getSavedArticles(limit: 10, lastDocument: null))
          .thenAnswer((_) async => Right(tArticles));

      //act
      final result = await viewModel.fetchSavedArticles(limit: 10);

      //assert
      result.fold(
        (failure) => fail('Expected success, but got failure: ${failure.errorMessage}'),
        (articles) => expect(articles, tArticles),
      );
      verify(mockRepository.getSavedArticles(limit: 10, lastDocument: null));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return empty list when no articles found', () async {
      //arrange
      when(mockRepository.getSavedArticles(limit: 10, lastDocument: null))
          .thenAnswer((_) async => const Right([]));

      //act
      final result = await viewModel.fetchSavedArticles(limit: 10);

      //assert
      result.fold(
        (failure) => fail('Expected success, but got failure: ${failure.errorMessage}'),
        (articles) => expect(articles, isEmpty),
      );
      verify(mockRepository.getSavedArticles(limit: 10, lastDocument: null));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test fetch saved articles', () {
    test('fail test should return server failure when repository call fails', () async {
      //arrange
      when(mockRepository.getSavedArticles(limit: 10, lastDocument: null))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await viewModel.fetchSavedArticles(limit: 10);

      //assert
      result.fold(
        (failure) => expect(failure.errorMessage, 'Server error'),
        (articles) => fail('Expected failure, but got success'),
      );
      verify(mockRepository.getSavedArticles(limit: 10, lastDocument: null));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.getSavedArticles(limit: 10, lastDocument: null))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await viewModel.fetchSavedArticles(limit: 10);

      //assert
      result.fold(
        (failure) => expect(failure.errorMessage, 'Connection error'),
        (articles) => fail('Expected failure, but got success'),
      );
      verify(mockRepository.getSavedArticles(limit: 10, lastDocument: null));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success test save article', () {
    test('success test should save article when repository call is successful', () async {
      //arrange
      when(mockRepository.saveArticle(tArticles[0]))
          .thenAnswer((_) async => const Right(null));

      //act
      await viewModel.saveArticle(tArticles[0]);

      //assert
      verify(mockRepository.saveArticle(tArticles[0]));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test save article', () {
    test('fail test should handle server failure when repository call fails', () async {
      //arrange
      when(mockRepository.saveArticle(tArticles[0]))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      await viewModel.saveArticle(tArticles[0]);

      //assert
      verify(mockRepository.saveArticle(tArticles[0]));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should handle connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.saveArticle(tArticles[0]))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      await viewModel.saveArticle(tArticles[0]);

      //assert
      verify(mockRepository.saveArticle(tArticles[0]));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success test remove article', () {
    test('success test should remove article when repository call is successful', () async {
      //arrange
      when(mockRepository.removeArticle(tArticleId))
          .thenAnswer((_) async => const Right(null));

      //act
      await viewModel.removeArticle(tArticleId);

      //assert
      verify(mockRepository.removeArticle(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test remove article', () {
    test('fail test should handle server failure when repository call fails', () async {
      //arrange
      when(mockRepository.removeArticle(tArticleId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      await viewModel.removeArticle(tArticleId);

      //assert
      verify(mockRepository.removeArticle(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should handle connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.removeArticle(tArticleId))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      await viewModel.removeArticle(tArticleId);

      //assert
      verify(mockRepository.removeArticle(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success test is article saved', () {
    test('success test should return true when article is saved', () async {
      //arrange
      when(mockRepository.isArticleSaved(tArticleId))
          .thenAnswer((_) async => const Right(true));

      //act
      final result = await viewModel.isArticleSaved(tArticleId);

      //assert
      expect(result, true);
      verify(mockRepository.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return false when article is not saved', () async {
      //arrange
      when(mockRepository.isArticleSaved(tArticleId))
          .thenAnswer((_) async => const Right(false));

      //act
      final result = await viewModel.isArticleSaved(tArticleId);

      //assert
      expect(result, false);
      verify(mockRepository.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test is article saved', () {
    test('fail test should return false when repository call fails', () async {
      //arrange
      when(mockRepository.isArticleSaved(tArticleId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await viewModel.isArticleSaved(tArticleId);

      //assert
      expect(result, false);
      verify(mockRepository.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success test get saved article ids', () {
    test('success test should return article ids when repository call is successful', () async {
      //arrange
      final tArticleIds = <String>{'1', '2', '3'};
      when(mockRepository.getSavedArticleIds())
          .thenAnswer((_) async => Right(tArticleIds));

      //act
      final result = await viewModel.getSavedArticleIds();

      //assert
      expect(result, tArticleIds);
      verify(mockRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test get saved article ids', () {
    test('fail test should return empty set when repository call fails', () async {
      //arrange
      when(mockRepository.getSavedArticleIds())
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await viewModel.getSavedArticleIds();

      //assert
      expect(result, isEmpty);
      verify(mockRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('success test search saved articles', () {
    test('success test should return articles when repository call is successful', () async {
      //arrange
      const query = 'test';
      when(mockRepository.searchSavedArticles(query))
          .thenAnswer((_) async => Right(tArticles));

      //act
      final result = await viewModel.searchSavedArticles(query);

      //assert
      expect(result, tArticles);
      verify(mockRepository.searchSavedArticles(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return empty list when no search results found', () async {
      //arrange
      const query = 'nonexistent';
      when(mockRepository.searchSavedArticles(query))
          .thenAnswer((_) async => const Right([]));

      //act
      final result = await viewModel.searchSavedArticles(query);

      //assert
      expect(result, isEmpty);
      verify(mockRepository.searchSavedArticles(query));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test search saved articles', () {
    test('fail test should return empty list when repository call fails', () async {
      //arrange
      const query = 'test';
      when(mockRepository.searchSavedArticles(query))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await viewModel.searchSavedArticles(query);

      //assert
      expect(result, isEmpty);
      verify(mockRepository.searchSavedArticles(query));
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 