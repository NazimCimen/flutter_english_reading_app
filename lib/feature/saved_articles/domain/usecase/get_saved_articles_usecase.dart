import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

class GetSavedArticlesUseCase {
  final SavedArticlesRepository repository;

  GetSavedArticlesUseCase(this.repository);

  Future<Either<Failure, List<ArticleModel>>> call({int? limit, DocumentSnapshot? lastDocument}) async {
    return await repository.getSavedArticles(limit: limit, lastDocument: lastDocument);
  }
} 