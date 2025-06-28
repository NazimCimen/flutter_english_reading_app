import 'package:english_reading_app/feature/home/repository/article_service.dart';
import 'package:english_reading_app/feature/saved_articles/data/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final ArticleService _articleService = ArticleService();
  final SavedArticlesRepository _savedArticlesRepository;
  
  // Cache for saved article IDs
  Set<String>? _savedArticleIdsCache;
  bool _isLoadingSavedIds = false;

  HomeViewModel({required SavedArticlesRepository savedArticlesRepository})
      : _savedArticlesRepository = savedArticlesRepository;

  Future<List<ArticleModel>> fetchArticles({
    required String? categoryFilter,
    int limit = 10,
    bool reset = false,
  }) async {
    return _articleService.getArticles(
      categoryFilter: categoryFilter,
      limit: 10,
      reset: reset,
    );
  }

  Future<void> saveArticle(ArticleModel article) async {
    try {
      await _savedArticlesRepository.saveArticle(article);
      
      // Update cache immediately
      _savedArticleIdsCache?.add(article.articleId!);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isArticleSaved(String articleId) async {
    try {
      // Use cache if available
      if (_savedArticleIdsCache != null) {
        return _savedArticleIdsCache!.contains(articleId);
      }
      
      // If cache is not available and not currently loading, load it
      if (!_isLoadingSavedIds) {
        await _loadSavedArticleIds();
      }
      
      return _savedArticleIdsCache?.contains(articleId) ?? false;
    } catch (e) {
      print('HomeViewModel: Error checking if article is saved: $e');
      return false;
    }
  }

  Future<void> _loadSavedArticleIds() async {
    if (_isLoadingSavedIds) return;
    
    try {
      _isLoadingSavedIds = true;
      _savedArticleIdsCache = await _savedArticlesRepository.getSavedArticleIds();
      notifyListeners();
    } catch (e) {
      print('HomeViewModel: Error loading saved article IDs: $e');
    } finally {
      _isLoadingSavedIds = false;
    }
  }

  // Method to preload saved article IDs (call this when home view loads)
  Future<void> preloadSavedArticleIds() async {
    await _loadSavedArticleIds();
  }

  // Method to clear cache when user logs out
  void clearCache() {
    _savedArticleIdsCache = null;
    _isLoadingSavedIds = false;
    notifyListeners();
  }
}
