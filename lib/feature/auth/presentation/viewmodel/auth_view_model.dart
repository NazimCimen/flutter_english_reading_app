import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/export.dart';

class AuthViewModel {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final CheckEmailVerificationUseCase checkEmailVerificationUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  final SaveUserToFirestoreUseCase saveUserToFirestoreUseCase;

  AuthViewModel({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.signInWithGoogleUseCase,
    required this.logoutUseCase,
    required this.sendEmailVerificationUseCase,
    required this.checkEmailVerificationUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.saveUserToFirestoreUseCase,
  });

  /// Signup with email and password
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    return await signupUseCase(
      email: email,
      password: password,
      name: name,
    );
  }

  /// Login with email and password
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    return await loginUseCase(
      email: email,
      password: password,
    );
  }

  /// Sign in with Google account
  /// Returns true if new user, false if existing user
  Future<Either<Failure, bool>> signInWithGoogle() async {
    return await signInWithGoogleUseCase();
  }

  /// Logout from all authentication providers
  Future<Either<Failure, void>> logout() async {
    return await logoutUseCase();
  }

  /// Send email verification to current user
  Future<Either<Failure, void>> sendEmailVerification() async {
    return await sendEmailVerificationUseCase();
  }

  /// Check if current user's email is verified
  Future<Either<Failure, bool>> checkEmailVerification() async {
    return await checkEmailVerificationUseCase();
  }

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    return await sendPasswordResetEmailUseCase(email: email);
  }

  /// Save current user to Firestore
  Future<Either<Failure, bool>> saveUserToFirestore() async {
    return await saveUserToFirestoreUseCase();
  }

  /// Get current authenticated user
  /// Note: This should be accessed through repository if needed
  /// For now, we can add this as a helper method
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Stream of authentication state changes
  /// Note: This should be accessed through repository if needed
  /// For now, we can add this as a helper method
  Stream<User?> getAuthStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
} 