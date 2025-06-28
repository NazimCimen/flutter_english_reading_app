import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class SavedArticlesLocalDataSource {
  Future<List<ArticleModel>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument});
  Future<void> saveArticle(ArticleModel article);
  Future<void> removeArticle(String articleId);
  Future<bool> isArticleSaved(String articleId);
}

class SavedArticlesLocalDataSourceImpl implements SavedArticlesLocalDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ArticleModel>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument}) async {
    try {
      Query query = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('saved_articles')
          .orderBy('savedAt', descending: true);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => const ArticleModel().fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get saved articles: $e');
    }
  }

  @override
  Future<void> saveArticle(ArticleModel article) async {
    try {
      // Convert article to JSON and manually handle the definition list
      final articleJson = article.toJson();
      final definitionList = article.definition?.map((d) => d.toJson()).toList();
      
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('saved_articles')
          .doc(article.articleId)
          .set({
        ...articleJson,
        'definition': definitionList,
        'savedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save article: $e');
    }
  }

  @override
  Future<void> removeArticle(String articleId) async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('saved_articles')
          .doc(articleId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove article: $e');
    }
  }

  @override
  Future<bool> isArticleSaved(String articleId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('saved_articles')
          .doc(articleId)
          .get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check if article is saved: $e');
    }
  }
} 