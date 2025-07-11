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

  Future<void> preloadSavedArticleIds() async {
    await _loadSavedArticleIds();
  }

  void clearCache() {
    _savedArticleIdsCache = null;
    _isLoadingSavedIds = false;
    notifyListeners();
  }
}
