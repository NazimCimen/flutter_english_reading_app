import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/splash/data/datasource/version_local_data_source.dart';
import 'package:english_reading_app/feature/splash/data/datasource/version_remote_data_source.dart';
import 'package:english_reading_app/feature/splash/data/repository/version_repository.dart';
import 'package:english_reading_app/product/model/version_model.dart';

class VersionRepositoryImpl implements VersionRepository {
  final VersionRemoteDataSource remoteDataSource;
  final VersionLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  VersionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VersionModel>> getVersionInfo() async {
    try {
      final isConnected = await networkInfo.currentConnectivityResult;
      
      if (isConnected) {
        // İnternet varsa remote'dan al
        final versionModel = await remoteDataSource.getVersionInfo();
        return Right(versionModel);
      } else {
        // İnternet yoksa local'den al
        final versionModel = await localDataSource.getCachedVersionInfo();
        return Right(versionModel);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.description ?? 'Cache error'));
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(errorMessage: e.description ?? 'Connection error'));
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }
} 