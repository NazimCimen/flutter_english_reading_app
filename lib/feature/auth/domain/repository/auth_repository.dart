import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';

abstract class AuthRepository {
  /// Creates a new user account with email and password
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String name,
  });

  /// Signs in user with email and password
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });

  /// Signs in user with Google account
  /// Returns true if user is new, false if existing user
  Future<Either<Failure, bool>> signInWithGoogle();

  /// Signs out user from all authentication providers
  Future<Either<Failure, void>> logout();

  /// Sends email verification to current authenticated user
  Future<Either<Failure, void>> sendEmailVerification();

  /// Checks if current user's email is verified
  Future<Either<Failure, bool>> checkEmailVerification();

  /// Sends password reset email to specified email address
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  /// Saves current authenticated user to Firestore
  Future<Either<Failure, bool>> saveUserToFirestore();
}
