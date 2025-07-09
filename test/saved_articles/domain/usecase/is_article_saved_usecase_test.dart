import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/is_article_saved_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'is_article_saved_usecase_test.mocks.dart';

@GenerateMocks([SavedArticlesRepository])
void main() {
  late IsArticleSavedUseCase useCase;
  late MockSavedArticlesRepository mockRepository;

  setUp(() {
    mockRepository = MockSavedArticlesRepository();
    useCase = IsArticleSavedUseCase(mockRepository);
  });

  const tArticleId = '1';

  group('success test is article saved', () {
    test('success test should return true when article is saved', () async {
      //arrange
      when(mockRepository.isArticleSaved(tArticleId))
          .thenAnswer((_) async => const Right(true));

      //act
      final result = await useCase(tArticleId);

      //assert
      expect(result, const Right(true));
      verify(mockRepository.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return false when article is not saved', () async {
      //arrange
      when(mockRepository.isArticleSaved(tArticleId))
          .thenAnswer((_) async => const Right(false));

      //act
      final result = await useCase(tArticleId);

      //assert
      expect(result, const Right(false));
      verify(mockRepository.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test is article saved', () {
    test('fail test should return server failure when repository call fails', () async {
      //arrange
      when(mockRepository.isArticleSaved(tArticleId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await useCase(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.isArticleSaved(tArticleId))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await useCase(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockRepository.isArticleSaved(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 