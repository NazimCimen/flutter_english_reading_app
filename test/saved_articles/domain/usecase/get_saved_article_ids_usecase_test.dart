import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/get_saved_article_ids_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_saved_article_ids_usecase_test.mocks.dart';

@GenerateMocks([SavedArticlesRepository])
void main() {
  late GetSavedArticleIdsUseCase useCase;
  late MockSavedArticlesRepository mockRepository;

  setUp(() {
    mockRepository = MockSavedArticlesRepository();
    useCase = GetSavedArticleIdsUseCase(mockRepository);
  });

  final tArticleIds = <String>{'1', '2', '3'};

  group('success test get saved article ids', () {
    test('success test should return article ids when repository call is successful', () async {
      //arrange
      when(mockRepository.getSavedArticleIds())
          .thenAnswer((_) async => Right(tArticleIds));

      //act
      final result = await useCase();

      //assert
      expect(result, Right(tArticleIds));
      verify(mockRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return empty set when no articles are saved', () async {
      //arrange
      when(mockRepository.getSavedArticleIds())
          .thenAnswer((_) async => const Right(<String>{}));

      //act
      final result = await useCase();

      //assert
      expect(result, const Right(<String>{}));
      verify(mockRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test get saved article ids', () {
    test('fail test should return server failure when repository call fails', () async {
      //arrange
      when(mockRepository.getSavedArticleIds())
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Server error')));

      //act
      final result = await useCase();

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(mockRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return connection failure when repository call fails', () async {
      //arrange
      when(mockRepository.getSavedArticleIds())
          .thenAnswer((_) async => Left(ConnectionFailure(errorMessage: 'Connection error')));

      //act
      final result = await useCase();

      //assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
      verify(mockRepository.getSavedArticleIds());
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 