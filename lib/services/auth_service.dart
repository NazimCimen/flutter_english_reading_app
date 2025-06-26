import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final useCred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = useCred.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.sendEmailVerification();

        return const Right(null);
      } else {
        return Left(ServerFailure(errorMessage: 'errorMessage'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    }
  }

  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    }
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
          return const Right(true); // Yeni kullanıcı
        } else {
          return const Right(false); // Mevcut kullanıcı
        }
      } else {
        return Left(
          ServerFailure(errorMessage: 'Kullanıcı bilgileri alınamadı'),
        );
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(errorMessage: e.code));
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}
