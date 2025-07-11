import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await remoteDataSource.signup(
        email: email,
        password: password,
        name: name,
      );
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
  }

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await remoteDataSource.login(
        email: email,
        password: password,
      );
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
  }

  @override
  Future<Either<Failure, bool>> signInWithGoogle() async {
    try {
      final isNewUser = await remoteDataSource.signInWithGoogle();
      return Right(isNewUser);
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

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on UnKnownException catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.description ?? 'Logout error'));
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
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
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerification() async {
    try {
      final isVerified = await remoteDataSource.checkEmailVerification();
      return Right(isVerified);
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

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email}) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
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
  }

  @override
  Future<Either<Failure, bool>> saveUserToFirestore() async {
    try {
      final result = await remoteDataSource.saveUserToFirestore();
      return Right(result);
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
} 
