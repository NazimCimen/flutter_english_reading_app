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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';

class SavedArticlesViewModel extends ChangeNotifier {
  final GetSavedArticlesUseCase _getSavedArticlesUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final IsArticleSavedUseCase _isArticleSavedUseCase;
  final GetSavedArticleIdsUseCase _getSavedArticleIdsUseCase;
  final SearchSavedArticlesUseCase _searchSavedArticlesUseCase;
  
  SavedArticlesViewModel({
    required SavedArticlesRepository repository,
  })  : _getSavedArticlesUseCase = GetSavedArticlesUseCase(repository),
        _saveArticleUseCase = SaveArticleUseCase(repository),
        _removeArticleUseCase = RemoveArticleUseCase(repository),
        _isArticleSavedUseCase = IsArticleSavedUseCase(repository),
        _getSavedArticleIdsUseCase = GetSavedArticleIdsUseCase(repository),
        _searchSavedArticlesUseCase = SearchSavedArticlesUseCase(repository);

  /// Fetch saved articles for pagination
  Future<Either<Failure, List<ArticleModel>>> fetchSavedArticles({
    int? limit,
    DocumentSnapshot? lastDocument,
  }) async {
    return _getSavedArticlesUseCase(limit: limit, lastDocument: lastDocument);
  }

  Future<void> saveArticle(ArticleModel article) async {
    final result = await _saveArticleUseCase(article);
    result.fold(
      (failure) {
        CustomSnackBars.showErrorSnackBar(failure.errorMessage);
      },
      (_) {
        CustomSnackBars.showSuccessSnackBar('Article saved successfully');
      },
    );
  }

  Future<void> removeArticle(String articleId) async {
    final result = await _removeArticleUseCase(articleId);
    result.fold(
      (failure) {
        CustomSnackBars.showErrorSnackBar(failure.errorMessage);
      },
      (_) {
        CustomSnackBars.showSuccessSnackBar('Article removed successfully');
      },
    );
  }

  Future<bool> isArticleSaved(String articleId) async {
    final result = await _isArticleSavedUseCase(articleId);
    return result.fold(
      (failure) => false,
      (isSaved) => isSaved,
    );
  }

  Future<Set<String>> getSavedArticleIds() async {
    final result = await _getSavedArticleIdsUseCase();
    return result.fold(
      (failure) => <String>{},
      (articleIds) => articleIds,
    );
  }

  /// Search saved articles
  Future<List<ArticleModel>> searchSavedArticles(String query) async {
    final result = await _searchSavedArticlesUseCase(query);
    return result.fold(
      (failure) => [],
      (articles) => articles,
    );
  }
} 