import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/services/user_service.dart';

abstract class AuthRemoteDataSource {
  /// Creates a new user account with email and password.
  /// Also sends email verification if possible.
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  });

  /// Signs in user with email and password.
  Future<void> login({required String email, required String password});

  /// Signs in user with Google account.
  /// Returns true if user is new, false if existing user.
  Future<bool> signInWithGoogle();

  /// Signs out user from all authentication providers.
  Future<void> logout();

  /// Sends email verification to current authenticated user.
  Future<void> sendEmailVerification();

  /// Checks if current user's email is verified.
  Future<bool> checkEmailVerification();

  /// Sends password reset email to specified email address.
  Future<void> sendPasswordResetEmail({required String email});

  /// Saves current authenticated user to Firestore.
  Future<bool> saveUserToFirestore();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final UserService userService;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.userService,
  });

  @override
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user;
      if (user != null) {
        await user.updateDisplayName(name);

        // Try to send email verification, but don't fail signup if it fails
        try {
          await user.sendEmailVerification();
        } catch (e) {
          // Email verification failed but signup is still successful
          // Don't throw exception, let user login anyway
        }
      } else {
        throw ServerException('Failed to create user');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.code);
    } on SocketException {
      throw ConnectionException('network-request-failed');
    } catch (e) {
      throw UnKnownException('unknown-error');
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.code);
    } on SocketException {
      throw ConnectionException('network-request-failed');
    } catch (e) {
      throw UnKnownException('unknown-error');
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw ServerException('Sign in cancelled by user');
      }

      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        // Check if user is new (first time signing in)
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          final success = await userService.setUserToFirestore();
          if (!success) {
            throw ServerException('Failed to save user information');
          }
        }

        return isNewUser;
      } else {
        throw ServerException('Failed to get user information');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.code);
    } on SocketException {
      throw ConnectionException('network-request-failed');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw UnKnownException('unknown-error');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
    } catch (e) {
      throw UnKnownException('Logout failed');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw ServerException('User not found');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.code);
    } on SocketException {
      throw ConnectionException('network-request-failed');
    } catch (e) {
      throw UnKnownException('unknown-error');
    }
  }

  @override
  Future<bool> checkEmailVerification() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      } else {
        throw ServerException('User not found');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.code);
    } on SocketException {
      throw ConnectionException('network-request-failed');
    } catch (e) {
      throw UnKnownException('unknown-error');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.code);
    } on SocketException {
      throw ConnectionException('network-request-failed');
    } catch (e) {
      throw UnKnownException('unknown-error');
    }
  }

  @override
  Future<bool> saveUserToFirestore() async {
    try {
      final success = await userService.setUserToFirestore();
      return success;
    } catch (e) {
      throw UnKnownException('Failed to save user to Firestore');
    }
  }
}
