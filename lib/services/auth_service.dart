import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  
  /// Firebase Auth işlemlerini güvenli şekilde wrapper eden metod
  Future<Either<Failure, T>> _safeFirebaseCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    } on PlatformException catch (e) {
      // PlatformException'ları Firebase Auth error code'larına çevir
      String errorCode = e.code;
      if (e.code == 'network-request-failed' || 
          e.message?.contains('network') == true ||
          e.message?.contains('connection') == true) {
        errorCode = 'network-request-failed';
      }
      return Left(ServerFailure(errorMessage: errorCode));
    } on SocketException catch (e) {
      return Left(ServerFailure(errorMessage: 'network-request-failed'));
    } catch (e) {
      // Generic error handling
      if (e.toString().contains('network-request-failed') ||
          e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('timeout')) {
        return Left(ServerFailure(errorMessage: 'network-request-failed'));
      }
      return Left(ServerFailure(errorMessage: 'unknown-error'));
    }
  }

  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _safeFirebaseCall(() async {
      final useCred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = useCred.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.sendEmailVerification();
        return;
      } else {
        throw Exception('Kullanıcı oluşturulamadı');
      }
    });
  }

  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    return await _safeFirebaseCall(() async {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<Either<Failure, bool>> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return Left(
          ServerFailure(
            errorMessage: 'Giriş işlemi kullanıcı tarafından iptal edildi',
          ),
        );
      }

      return await _safeFirebaseCall(() async {
        final googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          if (userCredential.additionalUserInfo?.isNewUser == true) {
            // Yeni kullanıcı, e-posta doğrulama ekranına yönlendir
            await user.sendEmailVerification();
            return true; // Yeni kullanıcı
          } else {
            return false; // Mevcut kullanıcı
          }
        } else {
          throw Exception('Kullanıcı bilgileri alınamadı');
        }
      });
    } catch (e) {
      if (e is ServerFailure) return Left(e);
      return Left(ServerFailure(errorMessage: 'unknown-error'));
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      // Logout hatalarını sessizce handle et
      print('Logout error: $e');
    }
  }

  Future<Either<Failure, void>> sendEmailVerification() async {
    return await _safeFirebaseCall(() async {
      final user = auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        return;
      } else {
        throw Exception('Kullanıcı bulunamadı');
      }
    });
  }

  /// Email verification durumunu kontrol eden güvenli metod
  Future<Either<Failure, bool>> checkEmailVerification() async {
    return await _safeFirebaseCall(() async {
      await auth.currentUser!.reload();
      return auth.currentUser!.emailVerified;
    });
  }
}
