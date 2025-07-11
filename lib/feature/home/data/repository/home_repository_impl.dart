import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:english_reading_app/feature/home/domain/repository/home_repository.dart';
import 'package:english_reading_app/product/model/article_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  
  HomeRepositoryImpl({required this.remoteDataSource});
  
  /// Fetches articles from remote data source and handles error conversion.
  /// Converts exceptions to appropriate Failure objects following clean architecture.
  @override
  Future<Either<Failure, List<ArticleModel>>> getArticles({
    String? categoryFilter,
    int limit = 10,
    bool reset = false,
  }) async {
    try {
      final articles = await remoteDataSource.getArticles(
        categoryFilter: categoryFilter,
        limit: limit,
        reset: reset,
      );
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
  }
  
  /// Delegates pagination reset to the remote data source.
  /// This clears any cached pagination state for fresh data fetching.
  @override
  void resetPagination() {
    remoteDataSource.resetPagination();
  }
} 