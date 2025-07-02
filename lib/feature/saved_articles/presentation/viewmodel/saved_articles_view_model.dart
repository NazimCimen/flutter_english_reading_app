import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/feature/saved_articles/data/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SavedArticlesViewModel extends ChangeNotifier {
  final SavedArticlesRepository _repository;
  final NetworkInfo _networkInfo;
  
  static const _pageSize = 10;
  
  final PagingController<int, ArticleModel> pagingController = PagingController(firstPageKey: 0);
  
  SavedArticlesViewModel({
    required SavedArticlesRepository repository,
    required NetworkInfo networkInfo,
  })  : _repository = repository,
        _networkInfo = networkInfo {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (await _networkInfo.currentConnectivityResult) {
        final isLastPage = pageKey >= 1000; // Arbitrary limit for demo
        if (isLastPage) {
          pagingController.appendLastPage([]);
        } else {
          final newItems = await _repository.getSavedArticles(limit: _pageSize);
          final isLastPage = newItems.length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + newItems.length;
            pagingController.appendPage(newItems, nextPageKey);
          }
        }
      } else {
        // Handle offline case
        pagingController.appendLastPage([]);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> removeArticle(String articleId) async {
    try {
      await _repository.removeArticle(articleId);
      // Refresh the list
      pagingController.refresh();
    } catch (error) {
      // Handle error
      print('Error removing article: $error');
    }
  }

  Future<bool> isArticleSaved(String articleId) async {
    try {
      return await _repository.isArticleSaved(articleId);
    } catch (error) {
      return false;
    }
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