import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class SavedArticlesRepository {
  Future<List<ArticleModel>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument});
  Future<void> saveArticle(ArticleModel article);
  Future<void> removeArticle(String articleId);
  Future<bool> isArticleSaved(String articleId);
  Future<Set<String>> getSavedArticleIds();
} 