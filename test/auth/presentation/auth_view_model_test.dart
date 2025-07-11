import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/signup_usecase.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/login_usecase.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/logout_usecase.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/send_email_verification_usecase.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/check_email_verification_usecase.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/send_password_reset_email_usecase.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/save_user_to_firestore_usecase.dart';
import 'package:english_reading_app/feature/auth/presentation/viewmodel/auth_view_model.dart';

import 'auth_view_model_test.mocks.dart';

@GenerateMocks([
  SignupUseCase,
  LoginUseCase,
  SignInWithGoogleUseCase,
  LogoutUseCase,
  SendEmailVerificationUseCase,
  CheckEmailVerificationUseCase,
  SendPasswordResetEmailUseCase,
  SaveUserToFirestoreUseCase,
])
void main() {
  late AuthViewModel viewModel;
  late MockSignupUseCase mockSignupUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockSendEmailVerificationUseCase mockSendEmailVerificationUseCase;
  late MockCheckEmailVerificationUseCase mockCheckEmailVerificationUseCase;
  late MockSendPasswordResetEmailUseCase mockSendPasswordResetEmailUseCase;
  late MockSaveUserToFirestoreUseCase mockSaveUserToFirestoreUseCase;

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockSendEmailVerificationUseCase = MockSendEmailVerificationUseCase();
    mockCheckEmailVerificationUseCase = MockCheckEmailVerificationUseCase();
    mockSendPasswordResetEmailUseCase = MockSendPasswordResetEmailUseCase();
    mockSaveUserToFirestoreUseCase = MockSaveUserToFirestoreUseCase();

    viewModel = AuthViewModel(
      signupUseCase: mockSignupUseCase,
      loginUseCase: mockLoginUseCase,
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      logoutUseCase: mockLogoutUseCase,
      sendEmailVerificationUseCase: mockSendEmailVerificationUseCase,
      checkEmailVerificationUseCase: mockCheckEmailVerificationUseCase,
      sendPasswordResetEmailUseCase: mockSendPasswordResetEmailUseCase,
      saveUserToFirestoreUseCase: mockSaveUserToFirestoreUseCase,
    );
  });

  group('success/fail test AuthViewModel signup', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testName = 'Test User';

    test('success test', () async {
      // arrange
      when(mockSignupUseCase(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenAnswer((_) async => const Right(null));

      // act
      final result = await viewModel.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      // assert
      expect(result, const Right(null));
      verify(mockSignupUseCase(
        email: testEmail,
        password: testPassword,
        name: testName,
      ));
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockSignupUseCase(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      // assert
      expect(result, Left(failure));
      verify(mockSignupUseCase(
        email: testEmail,
        password: testPassword,
        name: testName,
      ));
    });
  });

  group('success/fail test AuthViewModel login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('success test', () async {
      // arrange
      when(mockLoginUseCase(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => const Right(null));

      // act
      final result = await viewModel.login(
        email: testEmail,
        password: testPassword,
      );

      // assert
      expect(result, const Right(null));
      verify(mockLoginUseCase(
        email: testEmail,
        password: testPassword,
      ));
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockLoginUseCase(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.login(
        email: testEmail,
        password: testPassword,
      );

      // assert
      expect(result, Left(failure));
      verify(mockLoginUseCase(
        email: testEmail,
        password: testPassword,
      ));
    });
  });

  group('success/fail test AuthViewModel signInWithGoogle', () {
    test('success test', () async {
      // arrange
      when(mockSignInWithGoogleUseCase()).thenAnswer((_) async => const Right(true));

      // act
      final result = await viewModel.signInWithGoogle();

      // assert
      expect(result, const Right(true));
      verify(mockSignInWithGoogleUseCase());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockSignInWithGoogleUseCase()).thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.signInWithGoogle();

      // assert
      expect(result, Left(failure));
      verify(mockSignInWithGoogleUseCase());
    });
  });

  group('success/fail test AuthViewModel logout', () {
    test('success test', () async {
      // arrange
      when(mockLogoutUseCase()).thenAnswer((_) async => const Right(null));

      // act
      final result = await viewModel.logout();

      // assert
      expect(result, const Right(null));
      verify(mockLogoutUseCase());
    });

    test('fail test', () async {
      // arrange
      final failure = UnKnownFaliure(errorMessage: 'Logout error');
      when(mockLogoutUseCase()).thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.logout();

      // assert
      expect(result, Left(failure));
      verify(mockLogoutUseCase());
    });
  });

  group('success/fail test AuthViewModel sendEmailVerification', () {
    test('success test', () async {
      // arrange
      when(mockSendEmailVerificationUseCase()).thenAnswer((_) async => const Right(null));

      // act
      final result = await viewModel.sendEmailVerification();

      // assert
      expect(result, const Right(null));
      verify(mockSendEmailVerificationUseCase());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockSendEmailVerificationUseCase()).thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.sendEmailVerification();

      // assert
      expect(result, Left(failure));
      verify(mockSendEmailVerificationUseCase());
    });
  });

  group('success/fail test AuthViewModel checkEmailVerification', () {
    test('success test', () async {
      // arrange
      when(mockCheckEmailVerificationUseCase()).thenAnswer((_) async => const Right(true));

      // act
      final result = await viewModel.checkEmailVerification();

      // assert
      expect(result, const Right(true));
      verify(mockCheckEmailVerificationUseCase());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockCheckEmailVerificationUseCase()).thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.checkEmailVerification();

      // assert
      expect(result, Left(failure));
      verify(mockCheckEmailVerificationUseCase());
    });
  });

  group('success/fail test AuthViewModel sendPasswordResetEmail', () {
    const testEmail = 'test@example.com';

    test('success test', () async {
      // arrange
      when(mockSendPasswordResetEmailUseCase(email: testEmail))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await viewModel.sendPasswordResetEmail(email: testEmail);

      // assert
      expect(result, const Right(null));
      verify(mockSendPasswordResetEmailUseCase(email: testEmail));
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockSendPasswordResetEmailUseCase(email: testEmail))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.sendPasswordResetEmail(email: testEmail);

      // assert
      expect(result, Left(failure));
      verify(mockSendPasswordResetEmailUseCase(email: testEmail));
    });
  });

  group('success/fail test AuthViewModel saveUserToFirestore', () {
    test('success test', () async {
      // arrange
      when(mockSaveUserToFirestoreUseCase()).thenAnswer((_) async => const Right(true));

      // act
      final result = await viewModel.saveUserToFirestore();

      // assert
      expect(result, const Right(true));
      verify(mockSaveUserToFirestoreUseCase());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockSaveUserToFirestoreUseCase()).thenAnswer((_) async => Left(failure));

      // act
      final result = await viewModel.saveUserToFirestore();

      // assert
      expect(result, Left(failure));
      verify(mockSaveUserToFirestoreUseCase());
    });
  });
} 