import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/home/domain/repository/home_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

class GetArticlesUseCase {
  final HomeRepository repository;
  
  GetArticlesUseCase({required this.repository});
  
  Future<Either<Failure, List<ArticleModel>>> call({
    String? categoryFilter,
    int limit = 10,
    bool reset = false,
  }) async {
    return await repository.getArticles(
      categoryFilter: categoryFilter,
      limit: limit,
      reset: reset,
    );
  }
} 