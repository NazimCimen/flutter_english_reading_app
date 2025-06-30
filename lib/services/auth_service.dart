import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Abstract class defining authentication service contract
abstract class AuthService {
  /// Sign up with email and password
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String name,
  });

  /// Login with email and password
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });

  /// Sign in with Google account
  /// Returns true if new user, false if existing user
  Future<Either<Failure, bool>> signInWithGoogle();

  /// Logout from all authentication providers
  Future<void> logout();

  /// Send email verification to current user
  Future<Either<Failure, void>> sendEmailVerification();

  /// Check if current user's email is verified
  Future<Either<Failure, bool>> checkEmailVerification();

  /// Get current authenticated user
  User? get currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
}

/// Implementation of AuthService using Firebase Authentication
class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.sendEmailVerification();
        return const Right(null);
      } else {
        return Left(ServerFailure(errorMessage: 'Kullanıcı oluşturulamadı'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    } on SocketException catch (e) {
      return Left(ServerFailure(errorMessage: 'network-request-failed'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'unknown-error'));
    }
  }

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    } on SocketException catch (e) {
      return Left(ServerFailure(errorMessage: 'network-request-failed'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'unknown-error'));
    }
  }

  Future<Either<Failure, bool>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Left(
          ServerFailure(
            errorMessage: 'Giriş işlemi kullanıcı tarafından iptal edildi',
          ),
        );
      }

      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        return const Right(true); 
      } else {
        return Left(
          ServerFailure(errorMessage: 'Kullanıcı bilgileri alınamadı'),
        );
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      // Logout hatalarını sessizce handle et
      print('Logout error: $e');
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        return const Right(null);
      } else {
        return Left(ServerFailure(errorMessage: 'Kullanıcı bulunamadı'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    } on SocketException catch (e) {
      return Left(ServerFailure(errorMessage: 'network-request-failed'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'unknown-error'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        return Right(user.emailVerified);
      } else {
        return Left(ServerFailure(errorMessage: 'Kullanıcı bulunamadı'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    } on SocketException catch (e) {
      return Left(ServerFailure(errorMessage: 'network-request-failed'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'unknown-error'));
    }
  }
}
