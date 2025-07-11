import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/get_saved_articles_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/get_saved_article_ids_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/is_article_saved_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/remove_article_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/save_article_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/search_saved_articles_usecase.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SavedArticlesViewModel extends ChangeNotifier {
  final GetSavedArticlesUseCase _getSavedArticlesUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final IsArticleSavedUseCase _isArticleSavedUseCase;
  final GetSavedArticleIdsUseCase _getSavedArticleIdsUseCase;
  final SearchSavedArticlesUseCase _searchSavedArticlesUseCase;
  final NetworkInfo _networkInfo;

  static const _pageSize = 10;

  final PagingController<int, ArticleModel> pagingController = PagingController(
    firstPageKey: 0,
  );

  SavedArticlesViewModel({
    required SavedArticlesRepository repository,
    required NetworkInfo networkInfo,
  }) : _getSavedArticlesUseCase = GetSavedArticlesUseCase(repository),
       _saveArticleUseCase = SaveArticleUseCase(repository),
       _removeArticleUseCase = RemoveArticleUseCase(repository),
       _isArticleSavedUseCase = IsArticleSavedUseCase(repository),
       _getSavedArticleIdsUseCase = GetSavedArticleIdsUseCase(repository),
       _searchSavedArticlesUseCase = SearchSavedArticlesUseCase(repository),
       _networkInfo = networkInfo {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    final result = await _getSavedArticlesUseCase(limit: _pageSize);
    result.fold(
      (failure) {
        pagingController.error = failure.errorMessage;
      },
      (articles) {
        final isLastPage = articles.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(articles);
        } else {
          final nextPageKey = pageKey + articles.length;
          pagingController.appendPage(articles, nextPageKey);
        }
      },
    );
  }

  Future<void> saveArticle(ArticleModel article) async {
    final result = await _saveArticleUseCase(article);
    result.fold(
      (failure) {
        CustomSnackBars.showErrorSnackBar(failure.errorMessage);
      },
      (_) {
        CustomSnackBars.showSuccessSnackBar('Article saved successfully');
        pagingController.refresh();
      },
    );
  }

  /// Sayfa her init olduğunda çağrılacak metod
  Future<void> initialize() async {
    // PagingController'ı reset et ve ilk sayfayı yükle
    pagingController.refresh();
  }

  Future<void> removeArticle(String articleId) async {
    final result = await _removeArticleUseCase(articleId);
    result.fold(
      (failure) {
        CustomSnackBars.showErrorSnackBar(failure.errorMessage);
      },
      (_) {
        CustomSnackBars.showSuccessSnackBar('Article removed successfully');
        pagingController.refresh();
      },
    );
  }

  Future<bool> isArticleSaved(String articleId) async {
    final result = await _isArticleSavedUseCase(articleId);
    return result.fold((failure) => false, (isSaved) => isSaved);
  }

  Future<Set<String>> getSavedArticleIds() async {
    final result = await _getSavedArticleIdsUseCase();
    return result.fold((failure) => <String>{}, (articleIds) => articleIds);
  }

  /// Search saved articles
  Future<List<ArticleModel>> searchSavedArticles(String query) async {
    final result = await _searchSavedArticlesUseCase(query);
    return result.fold((failure) => [], (articles) => articles);
  }

  /// Reset SavedArticlesViewModel when user logs out
  void reset() {
    pagingController.itemList = [];
    pagingController.nextPageKey = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
