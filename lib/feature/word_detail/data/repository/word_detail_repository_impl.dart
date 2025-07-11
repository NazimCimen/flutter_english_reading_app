import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';

/// Implementation of word detail repository handling data operations
class WordDetailRepositoryImpl implements WordDetailRepository {
  final WordDetailRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  WordDetailRepositoryImpl({
    required WordDetailRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  /// Fetches word details from external API with network connectivity check
  @override
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromApi(
    String word,
  ) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final entries = await _remoteDataSource.getWordDetail(word);
        return Right(entries.isNotEmpty ? entries.first : null);
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

  /// Retrieves word details from Firestore database with network connectivity check
  @override
  Future<Either<Failure, DictionaryEntry?>> getWordDetailFromFirestore(
    String word,
  ) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final entry = await _remoteDataSource.getWordDetailFromFirestore(word);
        return Right(entry);
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

  /// Saves word entry to Firestore database with network connectivity check
  @override
  Future<Either<Failure, String>> saveWordToLocal(DictionaryEntry entry) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final docId = await _remoteDataSource.saveWordToFirestore(entry);
        return Right(docId);
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

  /// Checks if word exists in Firestore for a specific user with network connectivity check
  @override
  Future<Either<Failure, bool>> isWordSaved(String word, String userId) async {
    if (await _networkInfo.currentConnectivityResult) {
      try {
        final isSaved = await _remoteDataSource.isWordSavedInFirestore(word, userId);
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
}
