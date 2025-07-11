import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRepository, User])
void main() {
  late MockAuthRepository mockRepository;
  late MockUser mockUser;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockUser = MockUser();
  });

  group('success/fail test signup', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testName = 'Test User';

    test('success test should return Right when signup succeeds', () async {
      //arrange
      when(mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenAnswer((_) async => const Right(null));

      //act
      final result = await mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      //assert
      expect(result, const Right(null));
      verify(mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      ));
    });

    test('fail test should return ServerFailure when signup fails', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      //assert
      expect(result, Left(failure));
      verify(mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      ));
    });
  });

  group('success/fail test login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('success test should return Right when login succeeds', () async {
      //arrange
      when(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => const Right(null));

      //act
      final result = await mockRepository.login(
        email: testEmail,
        password: testPassword,
      );

      //assert
      expect(result, const Right(null));
      verify(mockRepository.login(
        email: testEmail,
        password: testPassword,
      ));
    });

    test('fail test should return ServerFailure when login fails', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.login(
        email: testEmail,
        password: testPassword,
      );

      //assert
      expect(result, Left(failure));
      verify(mockRepository.login(
        email: testEmail,
        password: testPassword,
      ));
    });
  });

  group('success/fail test signInWithGoogle', () {
    test('success test should return Right with true for new user', () async {
      //arrange
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => const Right(true));

      //act
      final result = await mockRepository.signInWithGoogle();

      //assert
      expect(result, const Right(true));
      verify(mockRepository.signInWithGoogle());
    });

    test('success test should return Right with false for existing user', () async {
      //arrange
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => const Right(false));

      //act
      final result = await mockRepository.signInWithGoogle();

      //assert
      expect(result, const Right(false));
      verify(mockRepository.signInWithGoogle());
    });

    test('fail test should return ServerFailure when Google sign-in fails', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.signInWithGoogle();

      //assert
      expect(result, Left(failure));
      verify(mockRepository.signInWithGoogle());
    });
  });

  group('success/fail test logout', () {
    test('success test should return Right when logout succeeds', () async {
      //arrange
      when(mockRepository.logout()).thenAnswer((_) async => const Right(null));

      //act
      final result = await mockRepository.logout();

      //assert
      expect(result, const Right(null));
      verify(mockRepository.logout());
    });

    test('fail test should return UnKnownFaliure when logout fails', () async {
      //arrange
      final failure = UnKnownFaliure(errorMessage: 'Logout error');
      when(mockRepository.logout()).thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.logout();

      //assert
      expect(result, Left(failure));
      verify(mockRepository.logout());
    });
  });

  group('success/fail test sendEmailVerification', () {
    test('success test should return Right when send email verification succeeds', () async {
      //arrange
      when(mockRepository.sendEmailVerification()).thenAnswer((_) async => const Right(null));

      //act
      final result = await mockRepository.sendEmailVerification();

      //assert
      expect(result, const Right(null));
      verify(mockRepository.sendEmailVerification());
    });

    test('fail test should return ServerFailure when send email verification fails', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.sendEmailVerification()).thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.sendEmailVerification();

      //assert
      expect(result, Left(failure));
      verify(mockRepository.sendEmailVerification());
    });
  });

  group('success/fail test checkEmailVerification', () {
    test('success test should return Right with true when email is verified', () async {
      //arrange
      when(mockRepository.checkEmailVerification()).thenAnswer((_) async => const Right(true));

      //act
      final result = await mockRepository.checkEmailVerification();

      //assert
      expect(result, const Right(true));
      verify(mockRepository.checkEmailVerification());
    });

    test('success test should return Right with false when email is not verified', () async {
      //arrange
      when(mockRepository.checkEmailVerification()).thenAnswer((_) async => const Right(false));

      //act
      final result = await mockRepository.checkEmailVerification();

      //assert
      expect(result, const Right(false));
      verify(mockRepository.checkEmailVerification());
    });

    test('fail test should return ServerFailure when check email verification fails', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.checkEmailVerification()).thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.checkEmailVerification();

      //assert
      expect(result, Left(failure));
      verify(mockRepository.checkEmailVerification());
    });
  });

  group('success/fail test sendPasswordResetEmail', () {
    const testEmail = 'test@example.com';

    test('success test should return Right when send password reset email succeeds', () async {
      //arrange
      when(mockRepository.sendPasswordResetEmail(email: testEmail))
          .thenAnswer((_) async => const Right(null));

      //act
      final result = await mockRepository.sendPasswordResetEmail(email: testEmail);

      //assert
      expect(result, const Right(null));
      verify(mockRepository.sendPasswordResetEmail(email: testEmail));
    });

    test('fail test should return ServerFailure when send password reset email fails', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.sendPasswordResetEmail(email: testEmail))
          .thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.sendPasswordResetEmail(email: testEmail);

      //assert
      expect(result, Left(failure));
      verify(mockRepository.sendPasswordResetEmail(email: testEmail));
    });
  });

  group('success/fail test saveUserToFirestore', () {
    test('success test should return Right with true when save user succeeds', () async {
      //arrange
      when(mockRepository.saveUserToFirestore()).thenAnswer((_) async => const Right(true));

      //act
      final result = await mockRepository.saveUserToFirestore();

      //assert
      expect(result, const Right(true));
      verify(mockRepository.saveUserToFirestore());
    });

    test('success test should return Right with false when save user fails', () async {
      //arrange
      when(mockRepository.saveUserToFirestore()).thenAnswer((_) async => const Right(false));

      //act
      final result = await mockRepository.saveUserToFirestore();

      //assert
      expect(result, const Right(false));
      verify(mockRepository.saveUserToFirestore());
    });

    test('fail test should return ServerFailure when save user fails', () async {
      //arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.saveUserToFirestore()).thenAnswer((_) async => Left(failure));

      //act
      final result = await mockRepository.saveUserToFirestore();

      //assert
      expect(result, Left(failure));
      verify(mockRepository.saveUserToFirestore());
    });
  });
} 