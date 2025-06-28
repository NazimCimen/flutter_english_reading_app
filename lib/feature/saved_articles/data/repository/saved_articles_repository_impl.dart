import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_local_data_source.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_remote_data_source.dart';
import 'package:english_reading_app/feature/saved_articles/data/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

class SavedArticlesRepositoryImpl implements SavedArticlesRepository {
  final SavedArticlesRemoteDataSource _remoteDataSource;
  final SavedArticlesLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  SavedArticlesRepositoryImpl({
    required SavedArticlesRemoteDataSource remoteDataSource,
    required SavedArticlesLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<List<ArticleModel>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument}) async {
    if (await _networkInfo.currentConnectivityResult) {
      return await _remoteDataSource.getSavedArticles(limit: limit, lastDocument: lastDocument);
    } else {
      return await _localDataSource.getSavedArticles(limit: limit, lastDocument: lastDocument);
    }
  }

  @override
  Future<void> saveArticle(ArticleModel article) async {
    try {
      final isConnected = await _networkInfo.currentConnectivityResult;
      
      if (isConnected) {
        await _remoteDataSource.saveArticle(article);
      } else {
        await _localDataSource.saveArticle(article);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeArticle(String articleId) async {
    if (await _networkInfo.currentConnectivityResult) {
      await _remoteDataSource.removeArticle(articleId);
    } else {
      await _localDataSource.removeArticle(articleId);
    }
  }

  @override
  Future<bool> isArticleSaved(String articleId) async {
    try {
      if (await _networkInfo.currentConnectivityResult) {
        return await _remoteDataSource.isArticleSaved(articleId);
      } else {
        return await _localDataSource.isArticleSaved(articleId);
      }
    } catch (e) {
      print('Repository: Error checking if article is saved: $e');
      return false;
    }
  }

  @override
  Future<Set<String>> getSavedArticleIds() async {
    try {
      if (await _networkInfo.currentConnectivityResult) {
        return await _remoteDataSource.getSavedArticleIds();
      } else {
        // For local, we'll return an empty set since we don't have this functionality
        return <String>{};
      }
    } catch (e) {
      print('Repository: Error getting saved article IDs: $e');
      return <String>{};
    }
  }
} 