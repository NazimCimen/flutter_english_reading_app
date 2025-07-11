import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ArticleModel>>> getArticles({
    String? categoryFilter,
    int limit = 10,
    bool reset = false,
  });
  
  void resetPagination();
} 