import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/remove_article_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_article_usecase_test.mocks.dart';

@GenerateMocks([SavedArticlesRepository])
void main() {
  late RemoveArticleUseCase useCase;
  late MockSavedArticlesRepository mockRepository;

  setUp(() {
    mockRepository = MockSavedArticlesRepository();
    useCase = RemoveArticleUseCase(mockRepository);
  });

  const tArticleId = '1';

  group('success test remove article', () {
    test('success test should remove article when repository call is successful', () async {
      //arrange
      when(mockRepository.removeArticle(tArticleId))
          .thenAnswer((_) async => const Right(null));

      //act
      final result = await useCase(tArticleId);

      //assert
      expect(result, const Right(null));
      verify(mockRepository.removeArticle(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test remove article', () {
    test('fail test should return server failure when repository call fails', () async {
      //arrange
      when(mockRepository.removeArticle(tArticleId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await useCase(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.removeArticle(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.removeArticle(tArticleId))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await useCase(tArticleId);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockRepository.removeArticle(tArticleId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 