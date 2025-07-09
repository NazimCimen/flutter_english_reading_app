import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class SavedArticlesRepository {
  Future<Either<Failure, List<ArticleModel>>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument});
  Future<Either<Failure, void>> saveArticle(ArticleModel article);
  Future<Either<Failure, void>> removeArticle(String articleId);
  Future<Either<Failure, bool>> isArticleSaved(String articleId);
  Future<Either<Failure, Set<String>>> getSavedArticleIds();
  Future<Either<Failure, List<ArticleModel>>> searchSavedArticles(String query);
} 