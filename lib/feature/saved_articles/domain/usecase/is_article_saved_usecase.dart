import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';

class IsArticleSavedUseCase {
  final SavedArticlesRepository repository;

  IsArticleSavedUseCase(this.repository);

  Future<Either<Failure, bool>> call(String articleId) async {
    return await repository.isArticleSaved(articleId);
  }
} 