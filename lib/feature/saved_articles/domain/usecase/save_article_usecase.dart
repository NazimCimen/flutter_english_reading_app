import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

class SaveArticleUseCase {
  final SavedArticlesRepository repository;

  SaveArticleUseCase(this.repository);

  Future<Either<Failure, void>> call(ArticleModel article) async {
    return await repository.saveArticle(article);
  }
} 