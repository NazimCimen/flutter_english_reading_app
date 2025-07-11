import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/profile/data/datasource/profile_remote_data_source.dart';
import 'package:english_reading_app/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final result = await remoteDataSource.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on UnKnownException catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUsername({
    required String newUsername,
  }) async {
    try {
      final result = await remoteDataSource.updateUsername(
        newUsername: newUsername,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on UnKnownException catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfileImage({
    required String imageUrl,
  }) async {
    try {
      final result = await remoteDataSource.updateProfileImage(
        imageUrl: imageUrl,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on UnKnownException catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await remoteDataSource.logout();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on UnKnownException catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'));
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }
} 