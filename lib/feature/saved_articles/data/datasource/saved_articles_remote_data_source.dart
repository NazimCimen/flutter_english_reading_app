import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class SavedArticlesRemoteDataSource {
  Future<List<ArticleModel>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument});
  Future<void> saveArticle(ArticleModel article);
  Future<void> removeArticle(String articleId);
  Future<bool> isArticleSaved(String articleId);
  Future<Set<String>> getSavedArticleIds();
}

class SavedArticlesRemoteDataSourceImpl implements SavedArticlesRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Cache for saved article IDs to avoid repeated Firestore calls
  Set<String>? _savedArticleIdsCache;
  DateTime? _cacheTimestamp;
  static const Duration _cacheValidity = Duration(minutes: 5);

  String? get _currentUserId => _auth.currentUser?.uid;

  // Check if cache is still valid
  bool get _isCacheValid {
    if (_cacheTimestamp == null || _savedArticleIdsCache == null) return false;
    return DateTime.now().difference(_cacheTimestamp!) < _cacheValidity;
  }

  // Clear cache when needed
  void _clearCache() {
    _savedArticleIdsCache = null;
    _cacheTimestamp = null;
  }

  @override
  Future<List<ArticleModel>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument}) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      Query query = _firestore
          .collection('users')
          .doc(_currentUserId)
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
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      if (article.articleId == null) {
        throw Exception('Article ID is null');
      }
      
      // Convert article to JSON and manually handle the definition list
      final articleJson = article.toJson();
      final definitionList = article.definition?.map((d) => d.toJson()).toList();
      
      // Use batch write for better performance
      final batch = _firestore.batch();
      
      // Save the article
      final articleRef = _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('saved_articles')
          .doc(article.articleId);
      
      batch.set(articleRef, {
        ...articleJson,
        'definition': definitionList,
        'savedAt': FieldValue.serverTimestamp(),
        'userId': _currentUserId, // For easier querying
      });
      
      // Update user's saved articles summary
      final userRef = _firestore.collection('users').doc(_currentUserId);
      batch.update(userRef, {
        'savedArticlesCount': FieldValue.increment(1),
        'lastSavedArticleAt': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
      
      // Update cache
      _savedArticleIdsCache?.add(article.articleId!);
    } catch (e) {
      throw Exception('Failed to save article: $e');
    }
  }

  @override
  Future<void> removeArticle(String articleId) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Use batch write for better performance
      final batch = _firestore.batch();
      
      // Remove the article
      final articleRef = _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('saved_articles')
          .doc(articleId);
      
      batch.delete(articleRef);
      
      // Update user's saved articles summary
      final userRef = _firestore.collection('users').doc(_currentUserId);
      batch.update(userRef, {
        'savedArticlesCount': FieldValue.increment(-1),
        'lastSavedArticleAt': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
      
      // Update cache
      _savedArticleIdsCache?.remove(articleId);
    } catch (e) {
      throw Exception('Failed to remove article: $e');
    }
  }

  @override
  Future<bool> isArticleSaved(String articleId) async {
    try {
      // Use cache if available and valid
      if (_isCacheValid) {
        return _savedArticleIdsCache!.contains(articleId);
      }
      
      // If cache is invalid, refresh it
      await getSavedArticleIds();
      return _savedArticleIdsCache!.contains(articleId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Set<String>> getSavedArticleIds() async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // If cache is valid, return cached data
      if (_isCacheValid) {
        return _savedArticleIdsCache!;
      }

      // Fetch from Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('saved_articles')
          .get();

      // Update cache
      _savedArticleIdsCache = querySnapshot.docs.map((doc) => doc.id).toSet();
      _cacheTimestamp = DateTime.now();

      return _savedArticleIdsCache!;
    } catch (e) {
      throw Exception('Failed to get saved article IDs: $e');
    }
  }

  // Method to clear cache when user logs out
  void clearCache() {
    _clearCache();
  }
} 