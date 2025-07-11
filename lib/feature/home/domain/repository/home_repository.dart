import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class HomeRepository {
  /// Fetches articles from the data source with optional filtering and pagination.
  /// Returns Either a Failure or a List of ArticleModel objects.
  Future<Either<Failure, List<ArticleModel>>> getArticles({
    String? categoryFilter,
    int limit = 10,
    bool reset = false,
  });
  
  /// Resets the pagination state to start fetching from the beginning.
  void resetPagination();
} 