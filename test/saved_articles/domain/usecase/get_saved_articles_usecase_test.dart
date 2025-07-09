import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/get_saved_articles_usecase.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_saved_articles_usecase_test.mocks.dart';

@GenerateMocks([SavedArticlesRepository])
void main() {
  late GetSavedArticlesUseCase useCase;
  late MockSavedArticlesRepository mockRepository;

  setUp(() {
    mockRepository = MockSavedArticlesRepository();
    useCase = GetSavedArticlesUseCase(mockRepository);
  });

  const tLimit = 10;
  final tLastDocument = MockDocumentSnapshot();
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

  group('success test get saved articles', () {
    test('success test should return list of articles when repository call is successful', () async {
      //arrange
      when(mockRepository.getSavedArticles(limit: tLimit, lastDocument: tLastDocument))
          .thenAnswer((_) async => Right(tArticles));

      //act
      final result = await useCase(limit: tLimit, lastDocument: tLastDocument);

      //assert
      expect(result, Right(tArticles));
      verify(mockRepository.getSavedArticles(limit: tLimit, lastDocument: tLastDocument));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return list of articles when repository call is successful without parameters', () async {
      //arrange
      when(mockRepository.getSavedArticles())
          .thenAnswer((_) async => Right(tArticles));

      //act
      final result = await useCase();

      //assert
      expect(result, Right(tArticles));
      verify(mockRepository.getSavedArticles());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test get saved articles', () {
    test('fail test should return server failure when repository call fails', () async {
      //arrange
      when(mockRepository.getSavedArticles(limit: tLimit, lastDocument: tLastDocument))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await useCase(limit: tLimit, lastDocument: tLastDocument);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.getSavedArticles(limit: tLimit, lastDocument: tLastDocument));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.getSavedArticles(limit: tLimit, lastDocument: tLastDocument))
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await useCase(limit: tLimit, lastDocument: tLastDocument);

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockRepository.getSavedArticles(limit: tLimit, lastDocument: tLastDocument));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {} 