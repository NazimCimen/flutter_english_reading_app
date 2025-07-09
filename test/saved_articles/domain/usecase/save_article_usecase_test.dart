import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/save_article_usecase.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_article_usecase_test.mocks.dart';

@GenerateMocks([SavedArticlesRepository])
void main() {
  late SaveArticleUseCase useCase;
  late MockSavedArticlesRepository mockRepository;

  setUp(() {
    mockRepository = MockSavedArticlesRepository();
    useCase = SaveArticleUseCase(mockRepository);
  });

  final tArticle = const ArticleModel(
    articleId: '1',
    title: 'Test Article',
    text: 'Test content',
  );

  group('success test save article', () {
    test('success test should save article when repository call is successful', () async {
      //arrange
      when(mockRepository.saveArticle(tArticle))
          .thenAnswer((_) async => const Right(null));

      //act
      final result = await useCase(tArticle);

      //assert
      expect(result, const Right(null));
      verify(mockRepository.saveArticle(tArticle));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test save article', () {
    test('fail test should return server failure when repository call fails', () async {
      //arrange
      when(mockRepository.saveArticle(tArticle))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await useCase(tArticle);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.saveArticle(tArticle));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.saveArticle(tArticle))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await useCase(tArticle);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockRepository.saveArticle(tArticle));
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 