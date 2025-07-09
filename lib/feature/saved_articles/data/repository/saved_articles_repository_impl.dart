import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_remote_data_source.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

class SavedArticlesRepositoryImpl implements SavedArticlesRepository {
  final SavedArticlesRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  SavedArticlesRepositoryImpl({
    required SavedArticlesRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ArticleModel>>> getSavedArticles({int? limit, DocumentSnapshot? lastDocument}) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final articles = await _remoteDataSource.getSavedArticles(limit: limit, lastDocument: lastDocument);
        return Right(articles);
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(errorMessage: e.description ?? 'Connection error'));
      } on UnKnownException catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
      } catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(errorMessage: 'No internet connection available'));
    }
  }

  @override
  Future<Either<Failure, void>> saveArticle(ArticleModel article) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        await _remoteDataSource.saveArticle(article);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(errorMessage: e.description ?? 'Connection error'));
      } on UnKnownException catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
      } catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(errorMessage: 'No internet connection available'));
    }
  }

  @override
  Future<Either<Failure, void>> removeArticle(String articleId) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        await _remoteDataSource.removeArticle(articleId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(errorMessage: e.description ?? 'Connection error'));
      } on UnKnownException catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
      } catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(errorMessage: 'No internet connection available'));
    }
  }

  @override
  Future<Either<Failure, bool>> isArticleSaved(String articleId) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final isSaved = await _remoteDataSource.isArticleSaved(articleId);
        return Right(isSaved);
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(errorMessage: e.description ?? 'Connection error'));
      } on UnKnownException catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
      } catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(errorMessage: 'No internet connection available'));
    }
  }

  @override
  Future<Either<Failure, Set<String>>> getSavedArticleIds() async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final articleIds = await _remoteDataSource.getSavedArticleIds();
        return Right(articleIds);
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(errorMessage: e.description ?? 'Connection error'));
      } on UnKnownException catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
      } catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(errorMessage: 'No internet connection available'));
    }
  }

  @override
  Future<Either<Failure, List<ArticleModel>>> searchSavedArticles(String query) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final articles = await _remoteDataSource.searchSavedArticles(query);
        return Right(articles);
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(errorMessage: e.description ?? 'Connection error'));
      } on UnKnownException catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
      } catch (e) {
        return Left(UnKnownFaliure(errorMessage: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(errorMessage: 'No internet connection available'));
    }
  }
} 