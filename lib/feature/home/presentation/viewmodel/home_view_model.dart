import 'package:english_reading_app/feature/home/domain/export.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final GetArticlesUseCase _getArticlesUseCase;
  final ResetPaginationUseCase _resetPaginationUseCase;
  final SavedArticlesRepository _savedArticlesRepository;
  
  // Cache for saved article IDs
  Set<String>? _savedArticleIdsCache;
  bool _isLoadingSavedIds = false;

  HomeViewModel({
    required GetArticlesUseCase getArticlesUseCase,
    required ResetPaginationUseCase resetPaginationUseCase,
    required SavedArticlesRepository savedArticlesRepository,
  })  : _getArticlesUseCase = getArticlesUseCase,
        _resetPaginationUseCase = resetPaginationUseCase,
        _savedArticlesRepository = savedArticlesRepository;

  /// Fetches articles using the get articles use case with error handling.
  /// Returns an empty list if an error occurs and logs the failure.
  Future<List<ArticleModel>> fetchArticles({
    required String? categoryFilter,
    int limit = 10,
    bool reset = false,
  }) async {
    final result = await _getArticlesUseCase.call(
      categoryFilter: categoryFilter,
      limit: limit,
      reset: reset,
    );
    
    return result.fold(
      (failure) {
        // Hata durumunda log veya snackbar eklenebilir
        print('HomeViewModel: Error fetching articles: ${failure.errorMessage}');
        return <ArticleModel>[];
      },
      (articles) => articles,
    );
  }

  /// Saves an article to the user's saved articles list.
  /// Updates the local cache and notifies listeners on success.
  Future<void> saveArticle(ArticleModel article) async {
    final result = await _savedArticlesRepository.saveArticle(article);
    result.fold(
      (failure) {
        // Hata durumunda log veya snackbar eklenebilir
        print('HomeViewModel: Error saving article: \\${failure.errorMessage}');
      },
      (_) {
        _savedArticleIdsCache?.add(article.articleId!);
        notifyListeners();
      },
    );
  }

  /// Removes an article from the user's saved articles list.
  /// Updates the local cache and notifies listeners on success.
  Future<void> removeArticle(String articleId) async {
    final result = await _savedArticlesRepository.removeArticle(articleId);
    result.fold(
      (failure) {
        print('HomeViewModel: Error removing article: \\${failure.errorMessage}');
      },
      (_) {
        _savedArticleIdsCache?.remove(articleId);
        notifyListeners();
      },
    );
  }

  /// Checks if an article is saved in the user's saved articles list.
  /// Returns true if saved, false otherwise or if cache is not loaded.
  bool isArticleSaved(String articleId) {
    try {
      if (_savedArticleIdsCache != null) {
        return _savedArticleIdsCache!.contains(articleId);
      }
      return false;
    } catch (e) {
      print('HomeViewModel: Error checking if article is saved: $e');
      return false;
    }
  }

  /// Loads saved article IDs from the repository and caches them locally.
  /// Prevents multiple concurrent loading operations.
  Future<void> _loadSavedArticleIds() async {
    if (_isLoadingSavedIds) return;
    try {
      _isLoadingSavedIds = true;
      final result = await _savedArticlesRepository.getSavedArticleIds();
      result.fold(
        (failure) {
          print('HomeViewModel: Error loading saved article IDs: \\${failure.errorMessage}');
        },
        (ids) {
          _savedArticleIdsCache = ids;
          notifyListeners();
        },
      );
    } finally {
      _isLoadingSavedIds = false;
    }
  }

  /// Public method to preload saved article IDs for better performance.
  /// Should be called early in the app lifecycle.
  Future<void> preloadSavedArticleIds() async {
    await _loadSavedArticleIds();
  }

  /// Clears the cached saved article IDs and resets loading state.
  /// Should be called when user logs out or data needs to be refreshed.
  void clearCache() {
    _savedArticleIdsCache = null;
    _isLoadingSavedIds = false;
    notifyListeners();
  }
}
