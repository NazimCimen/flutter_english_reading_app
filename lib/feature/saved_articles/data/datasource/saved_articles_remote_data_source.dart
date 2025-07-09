import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class SavedArticlesRemoteDataSource {
  Future<List<ArticleModel>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument});
  Future<void> saveArticle(ArticleModel article);
  Future<void> removeArticle(String articleId);
  Future<bool> isArticleSaved(String articleId);
  Future<Set<String>> getSavedArticleIds();
  Future<List<ArticleModel>> searchSavedArticles(String query);
}

class SavedArticlesRemoteDataSourceImpl implements SavedArticlesRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  // Cache for saved article IDs to avoid repeated Firestore calls
  Set<String>? _savedArticleIdsCache;
  DateTime? _cacheTimestamp;
  static const Duration _cacheValidity = Duration(minutes: 5);

  SavedArticlesRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

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
    if (_currentUserId == null) {
      throw ServerException('User not authenticated');
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
  }

  @override
  Future<void> saveArticle(ArticleModel article) async {
    if (_currentUserId == null) {
      throw ServerException('User not authenticated');
    }
    
    if (article.articleId == null) {
      throw ServerException('Article ID is null');
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
  }

  @override
  Future<void> removeArticle(String articleId) async {
    if (_currentUserId == null) {
      throw ServerException('User not authenticated');
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
  }

  @override
  Future<bool> isArticleSaved(String articleId) async {
    // Use cache if available and valid
    if (_isCacheValid) {
      return _savedArticleIdsCache!.contains(articleId);
    }
    
    // If cache is invalid, refresh it
    await getSavedArticleIds();
    return _savedArticleIdsCache!.contains(articleId);
  }

  @override
  Future<Set<String>> getSavedArticleIds() async {
    if (_currentUserId == null) {
      throw ServerException('User not authenticated');
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
  }

  // Method to clear cache when user logs out
  void clearCache() {
    _clearCache();
  }

  @override
  Future<List<ArticleModel>> searchSavedArticles(String query) async {
    if (_currentUserId == null) {
      throw ServerException('User not authenticated');
    }

    if (query.trim().isEmpty) {
      return [];
    }

    // Tüm saved articles'ı getir ve client-side'da filtrele
    final querySnapshot = await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('saved_articles')
        .orderBy('savedAt', descending: true)
        .get();

    final allArticles = querySnapshot.docs
        .map((doc) => const ArticleModel().fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Case-insensitive arama yap
    final lowercaseQuery = query.toLowerCase().trim();
    return allArticles.where((article) {
      final title = article.title?.toLowerCase() ?? '';
      return title.contains(lowercaseQuery);
    }).toList();
  }
} 