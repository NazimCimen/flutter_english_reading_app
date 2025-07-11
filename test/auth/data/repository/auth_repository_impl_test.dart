// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:english_reading_app/feature/auth/data/repository/auth_repository_impl.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthRemoteDataSource,
  User,
])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockUser mockUser;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockUser = MockUser();
    repository = AuthRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('success/fail test signup', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testName = 'Test User';

    test('success test should return Right when signup succeeds', () async {
      //arrange
      when(mockRemoteDataSource.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenAnswer((_) async {});

      //act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      //assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      ));
    });

    test('fail test should return ServerFailure when ServerException occurs', () async {
      //arrange
      when(mockRemoteDataSource.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenThrow(ServerException('Server error'));

      //act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      //assert
      expect(result, isA<Left<Failure, void>>());
      expect((result as Left).value, isA<ServerFailure>());
    });

    test('fail test should return ConnectionFailure when ConnectionException occurs', () async {
      //arrange
      when(mockRemoteDataSource.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenThrow(ConnectionException('Connection error'));

      //act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      //assert
      expect(result, isA<Left<Failure, void>>());
      expect((result as Left).value, isA<ConnectionFailure>());
    });

    test('fail test should return UnKnownFaliure when UnKnownException occurs', () async {
      //arrange
      when(mockRemoteDataSource.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenThrow(UnKnownException('Unknown error'));

      //act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      //assert
      expect(result, isA<Left<Failure, void>>());
      expect((result as Left).value, isA<UnKnownFaliure>());
    });
  });

  group('success/fail test login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('success test should return Right when login succeeds', () async {
      //arrange
      when(mockRemoteDataSource.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async {});

      //act
      final result = await repository.login(
        email: testEmail,
        password: testPassword,
      );

      //assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.login(
        email: testEmail,
        password: testPassword,
      ));
    });

    test('fail test should return ServerFailure when ServerException occurs', () async {
      //arrange
      when(mockRemoteDataSource.login(
        email: testEmail,
        password: testPassword,
      )).thenThrow(ServerException('Server error'));

      //act
      final result = await repository.login(
        email: testEmail,
        password: testPassword,
      );

      //assert
      expect(result, isA<Left<Failure, void>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('success/fail test signInWithGoogle', () {
    test('success test should return Right with true when Google sign-in succeeds for new user', () async {
      //arrange
      when(mockRemoteDataSource.signInWithGoogle()).thenAnswer((_) async => true);

      //act
      final result = await repository.signInWithGoogle();

      //assert
      expect(result, const Right(true));
      verify(mockRemoteDataSource.signInWithGoogle());
    });

    test('success test should return Right with false when Google sign-in succeeds for existing user', () async {
      //arrange
      when(mockRemoteDataSource.signInWithGoogle()).thenAnswer((_) async => false);

      //act
      final result = await repository.signInWithGoogle();

      //assert
      expect(result, const Right(false));
      verify(mockRemoteDataSource.signInWithGoogle());
    });

    test('fail test should return ServerFailure when ServerException occurs', () async {
      //arrange
      when(mockRemoteDataSource.signInWithGoogle()).thenThrow(ServerException('Server error'));

      //act
      final result = await repository.signInWithGoogle();

      //assert
      expect(result, isA<Left<Failure, bool>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('success/fail test logout', () {
    test('success test should return Right when logout succeeds', () async {
      //arrange
      when(mockRemoteDataSource.logout()).thenAnswer((_) async {});

      //act
      final result = await repository.logout();

      //assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.logout());
    });

    test('fail test should return UnKnownFaliure when UnKnownException occurs', () async {
      //arrange
      when(mockRemoteDataSource.logout()).thenThrow(UnKnownException('Logout error'));

      //act
      final result = await repository.logout();

      //assert
      expect(result, isA<Left<Failure, void>>());
      expect((result as Left).value, isA<UnKnownFaliure>());
    });
  });

  group('success/fail test sendEmailVerification', () {
    test('success test should return Right when send email verification succeeds', () async {
      //arrange
      when(mockRemoteDataSource.sendEmailVerification()).thenAnswer((_) async {});

      //act
      final result = await repository.sendEmailVerification();

      //assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.sendEmailVerification());
    });

    test('fail test should return ServerFailure when ServerException occurs', () async {
      //arrange
      when(mockRemoteDataSource.sendEmailVerification()).thenThrow(ServerException('Server error'));

      //act
      final result = await repository.sendEmailVerification();

      //assert
      expect(result, isA<Left<Failure, void>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('success/fail test checkEmailVerification', () {
    test('success test should return Right with true when email is verified', () async {
      //arrange
      when(mockRemoteDataSource.checkEmailVerification()).thenAnswer((_) async => true);

      //act
      final result = await repository.checkEmailVerification();

      //assert
      expect(result, const Right(true));
      verify(mockRemoteDataSource.checkEmailVerification());
    });

    test('success test should return Right with false when email is not verified', () async {
      //arrange
      when(mockRemoteDataSource.checkEmailVerification()).thenAnswer((_) async => false);

      //act
      final result = await repository.checkEmailVerification();

      //assert
      expect(result, const Right(false));
      verify(mockRemoteDataSource.checkEmailVerification());
    });

    test('fail test should return ServerFailure when ServerException occurs', () async {
      //arrange
      when(mockRemoteDataSource.checkEmailVerification()).thenThrow(ServerException('Server error'));

      //act
      final result = await repository.checkEmailVerification();

      //assert
      expect(result, isA<Left<Failure, bool>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('success/fail test sendPasswordResetEmail', () {
    const testEmail = 'test@example.com';

    test('success test should return Right when send password reset email succeeds', () async {
      //arrange
      when(mockRemoteDataSource.sendPasswordResetEmail(email: testEmail))
          .thenAnswer((_) async {});

      //act
      final result = await repository.sendPasswordResetEmail(email: testEmail);

      //assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.sendPasswordResetEmail(email: testEmail));
    });

    test('fail test should return ServerFailure when ServerException occurs', () async {
      //arrange
      when(mockRemoteDataSource.sendPasswordResetEmail(email: testEmail))
          .thenThrow(ServerException('Server error'));

      //act
      final result = await repository.sendPasswordResetEmail(email: testEmail);

      //assert
      expect(result, isA<Left<Failure, void>>());
      expect((result as Left).value, isA<ServerFailure>());
    });
  });

  group('success/fail test saveUserToFirestore', () {
    test('success test should return Right with true when save user succeeds', () async {
      //arrange
      when(mockRemoteDataSource.saveUserToFirestore()).thenAnswer((_) async => true);

      //act
      final result = await repository.saveUserToFirestore();

      //assert
      expect(result, const Right(true));
      verify(mockRemoteDataSource.saveUserToFirestore());
    });

    test('success test should return Right with false when save user fails', () async {
      //arrange
      when(mockRemoteDataSource.saveUserToFirestore()).thenAnswer((_) async => false);

      //act
      final result = await repository.saveUserToFirestore();

      //assert
      expect(result, const Right(false));
      verify(mockRemoteDataSource.saveUserToFirestore());
    });

    test('fail test should return UnKnownFaliure when UnKnownException occurs', () async {
      //arrange
      when(mockRemoteDataSource.saveUserToFirestore()).thenThrow(UnKnownException('Save error'));

      //act
      final result = await repository.saveUserToFirestore();

      //assert
      expect(result, isA<Left<Failure, bool>>());
      expect((result as Left).value, isA<UnKnownFaliure>());
    });
  });
} 