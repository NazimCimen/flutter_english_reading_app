import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_local_data_source.dart';
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_remote_data_source.dart';
import 'package:english_reading_app/feature/word_bank/data/repository/word_bank_repository.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/services/user_service.dart';

class WordBankRepositoryImpl implements WordBankRepository {
  final WordBankRemoteDataSource remoteDataSource;
  final WordBankLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final UserService userService;

  WordBankRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.userService,
  });

  @override
  Future<Either<Failure, List<DictionaryEntry>>> getWords({
    int limit = 10,
    bool reset = false,
  }) async {
    try {
      final userId = userService.getUserId();
      if (userId == null) {
        return Left(ServerFailure(errorMessage: 'User not authenticated'));
      }

      final isConnected = await networkInfo.currentConnectivityResult;

      if (isConnected) {
        final words = await remoteDataSource.getWords(
          userId: userId,
          reset: reset,
        );
        return Right(words);
      } else {
        return Left(
          ConnectionFailure(
            errorMessage: 'İnternet Bağlantınızı kontrol edin.',
          ),
        );
        /* final words = await localDataSource.getWords();
        return Right(words);*/
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.description ?? 'Cache error'));
    } on ConnectionException catch (e) {
      return Left(
        ConnectionFailure(errorMessage: e.description ?? 'Connection error'),
      );
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addWord(DictionaryEntry word) async {
    try {
      final userId = userService.getUserId();
      if (userId == null) {
        return Left(ServerFailure(errorMessage: 'User not authenticated'));
      }

      final wordWithUserId = word.copyWith(
        userId: userId,
        createdAt: DateTime.now(),
      );

      final isConnected = await networkInfo.currentConnectivityResult;

      if (isConnected) {
        // İnternet varsa remote'a kaydet
        final docId = await remoteDataSource.addWord(wordWithUserId);

        // Local'e de kaydet (cache için)
        final wordWithId = wordWithUserId.copyWith(documentId: docId);
        await localDataSource.addWord(wordWithId);

        return Right(docId);
      } else {
        // İnternet yoksa sadece local'e kaydet
        await localDataSource.addWord(wordWithUserId);
        return Right('local_${DateTime.now().millisecondsSinceEpoch}');
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.description ?? 'Cache error'));
    } on ConnectionException catch (e) {
      return Left(
        ConnectionFailure(errorMessage: e.description ?? 'Connection error'),
      );
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWord(DictionaryEntry word) async {
    try {
      final isConnected = await networkInfo.currentConnectivityResult;

      if (isConnected) {
        // İnternet varsa remote'ı güncelle
        await remoteDataSource.updateWord(word);

        // Local'i de güncelle
        await localDataSource.updateWord(word);
      } else {
        // İnternet yoksa sadece local'i güncelle
        await localDataSource.updateWord(word);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.description ?? 'Cache error'));
    } on ConnectionException catch (e) {
      return Left(
        ConnectionFailure(errorMessage: e.description ?? 'Connection error'),
      );
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWord(String documentId) async {
    try {
      final isConnected = await networkInfo.currentConnectivityResult;

      if (isConnected) {
        // İnternet varsa remote'dan sil
        await remoteDataSource.deleteWord(documentId);

        // Local'den de sil
        await localDataSource.deleteWord(documentId);
      } else {
        // İnternet yoksa sadece local'den sil
        await localDataSource.deleteWord(documentId);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.description ?? 'Cache error'));
    } on ConnectionException catch (e) {
      return Left(
        ConnectionFailure(errorMessage: e.description ?? 'Connection error'),
      );
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }
}
