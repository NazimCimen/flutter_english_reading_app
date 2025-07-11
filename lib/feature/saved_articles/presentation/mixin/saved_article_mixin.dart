import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

/// Mixin for managing pagination logic in SavedArticlesView
mixin SavedArticleMixin<T extends StatefulWidget> on State<T> {
  // PagingController managed at Mixin level
  final PagingController<int, ArticleModel> _pagingController = PagingController(firstPageKey: 0);
  static const _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  
  /// Getter for accessing the PagingController
  PagingController<int, ArticleModel> get pagingController => _pagingController;
  
  /// Initialize pagination setup
  void initializePagination() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }
  
  /// Dispose pagination resources
  void disposePagination() {
    _pagingController.dispose();
  }
  
  /// Fetch page data from ViewModel
  Future<void> _fetchPage(int pageKey) async {
    if (!mounted) return;
    
    final viewModel = context.read<SavedArticlesViewModel>();
    final result = await viewModel.fetchSavedArticles(
      limit: _pageSize,
      lastDocument: pageKey == 0 ? null : _lastDocument,
    );

    result.fold(
      (failure) {
        _pagingController.error = failure.errorMessage;
      },
      (articles) {
        final isLastPage = articles.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(articles);
        } else {
          final nextPageKey = pageKey + articles.length;
          _pagingController.appendPage(articles, nextPageKey);
        }
      },
    );
  }
  
  /// Refresh pagination - reset and reload
  void refreshPagination() {
    _lastDocument = null;
    _pagingController.refresh();
  }
  
  /// Clear pagination state
  void clearPagination() {
    _lastDocument = null;
    _pagingController.itemList = [];
    _pagingController.nextPageKey = 0;
  }
}
