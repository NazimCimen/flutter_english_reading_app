import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';

class RemoveArticleUseCase {
  final SavedArticlesRepository repository;

  RemoveArticleUseCase(this.repository);

  Future<Either<Failure, void>> call(String articleId) async {
    return await repository.removeArticle(articleId);
  }
} 