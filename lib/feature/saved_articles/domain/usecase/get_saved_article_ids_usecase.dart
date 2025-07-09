import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';

class GetSavedArticleIdsUseCase {
  final SavedArticlesRepository repository;

  GetSavedArticleIdsUseCase(this.repository);

  Future<Either<Failure, Set<String>>> call() async {
    return await repository.getSavedArticleIds();
  }
} 