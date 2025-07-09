import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

class SearchSavedArticlesUseCase {
  final SavedArticlesRepository repository;

  SearchSavedArticlesUseCase(this.repository);

  Future<Either<Failure, List<ArticleModel>>> call(String query) async {
    return await repository.searchSavedArticles(query);
  }
} 