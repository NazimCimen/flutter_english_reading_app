import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:english_reading_app/product/services/user_service.dart';

import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  GoogleSignIn,
  UserService,
  User,
  UserCredential,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  AdditionalUserInfo,
])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUserService mockUserService;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  late MockAdditionalUserInfo mockAdditionalUserInfo;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserService = MockUserService();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    mockAdditionalUserInfo = MockAdditionalUserInfo();
    
    dataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
      userService: mockUserService,
    );
  });

  group('success/fail test signup', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testName = 'Test User';

    test('success test should complete signup when Firebase Auth succeeds', () async {
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.updateDisplayName(testName)).thenAnswer((_) async {});
      when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

      //act
      await dataSource.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      //assert
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      ));
      verify(mockUser.updateDisplayName(testName));
      verify(mockUser.sendEmailVerification());
    });

    test('fail test should throw ServerException when FirebaseAuthException occurs', () async {
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(FirebaseAuthException(code: 'weak-password'));

      //act & assert
      expect(
        () => dataSource.signup(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw ConnectionException when SocketException occurs', () async {
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(const SocketException('Network error'));

      //act & assert
      expect(
        () => dataSource.signup(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
        throwsA(isA<ConnectionException>()),
      );
    });

    test('fail test should throw ServerException when user is null', () async {
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(null);

      //act & assert
      expect(
        () => dataSource.signup(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('success/fail test login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('success test should complete login when Firebase Auth succeeds', () async {
      //arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      //act
      await dataSource.login(email: testEmail, password: testPassword);

      //assert
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      ));
    });

    test('fail test should throw ServerException when FirebaseAuthException occurs', () async {
      //arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      //act & assert
      expect(
        () => dataSource.login(email: testEmail, password: testPassword),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw ConnectionException when SocketException occurs', () async {
      //arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(const SocketException('Network error'));

      //act & assert
      expect(
        () => dataSource.login(email: testEmail, password: testPassword),
        throwsA(isA<ConnectionException>()),
      );
    });
  });

  group('success/fail test signInWithGoogle', () {
    test('success test should return true for new user when Google sign-in succeeds', () async {
      //arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn('access_token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id_token');
      when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalUserInfo);
      when(mockAdditionalUserInfo.isNewUser).thenReturn(true);
      when(mockUserService.setUserToFirestore()).thenAnswer((_) async => true);

      //act
      final result = await dataSource.signInWithGoogle();

      //assert
      expect(result, true);
      verify(mockGoogleSignIn.signIn());
      verify(mockUserService.setUserToFirestore());
    });

    test('success test should return false for existing user when Google sign-in succeeds', () async {
      //arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn('access_token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id_token');
      when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalUserInfo);
      when(mockAdditionalUserInfo.isNewUser).thenReturn(false);

      //act
      final result = await dataSource.signInWithGoogle();

      //assert
      expect(result, false);
      verify(mockGoogleSignIn.signIn());
      verifyNever(mockUserService.setUserToFirestore());
    });

    test('fail test should throw ServerException when Google sign-in is cancelled', () async {
      //arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      //act & assert
      expect(
        () => dataSource.signInWithGoogle(),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw ServerException when Firestore save fails for new user', () async {
      //arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn('access_token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id_token');
      when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalUserInfo);
      when(mockAdditionalUserInfo.isNewUser).thenReturn(true);
      when(mockUserService.setUserToFirestore()).thenAnswer((_) async => false);

      //act & assert
      expect(
        () => dataSource.signInWithGoogle(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('success/fail test logout', () {
    test('success test should complete logout when both services succeed', () async {
      //arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      //act
      await dataSource.logout();

      //assert
      verify(mockFirebaseAuth.signOut());
      verify(mockGoogleSignIn.signOut());
    });

    test('fail test should throw UnKnownException when logout fails', () async {
      //arrange
      when(mockFirebaseAuth.signOut()).thenThrow(Exception('Logout failed'));

      //act & assert
      expect(
        () => dataSource.logout(),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('success/fail test sendEmailVerification', () {
    test('success test should send email verification when user exists', () async {
      //arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

      //act
      await dataSource.sendEmailVerification();

      //assert
      verify(mockUser.sendEmailVerification());
    });

    test('fail test should throw ServerException when user is null', () async {
      //arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      //act & assert
      expect(
        () => dataSource.sendEmailVerification(),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('success/fail test checkEmailVerification', () {
    test('success test should return true when email is verified', () async {
      //arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.reload()).thenAnswer((_) async {});
      when(mockUser.emailVerified).thenReturn(true);

      //act
      final result = await dataSource.checkEmailVerification();

      //assert
      expect(result, true);
      verify(mockUser.reload());
    });

    test('success test should return false when email is not verified', () async {
      //arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.reload()).thenAnswer((_) async {});
      when(mockUser.emailVerified).thenReturn(false);

      //act
      final result = await dataSource.checkEmailVerification();

      //assert
      expect(result, false);
      verify(mockUser.reload());
    });

    test('fail test should throw ServerException when user is null', () async {
      //arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      //act & assert
      expect(
        () => dataSource.checkEmailVerification(),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('success/fail test sendPasswordResetEmail', () {
    const testEmail = 'test@example.com';

    test('success test should send password reset email when Firebase Auth succeeds', () async {
      //arrange
      when(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
          .thenAnswer((_) async {});

      //act
      await dataSource.sendPasswordResetEmail(email: testEmail);

      //assert
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail));
    });

    test('fail test should throw ServerException when FirebaseAuthException occurs', () async {
      //arrange
      when(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      //act & assert
      expect(
        () => dataSource.sendPasswordResetEmail(email: testEmail),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('success/fail test saveUserToFirestore', () {
    test('success test should return true when user service succeeds', () async {
      //arrange
      when(mockUserService.setUserToFirestore()).thenAnswer((_) async => true);

      //act
      final result = await dataSource.saveUserToFirestore();

      //assert
      expect(result, true);
      verify(mockUserService.setUserToFirestore());
    });

    test('success test should return false when user service fails', () async {
      //arrange
      when(mockUserService.setUserToFirestore()).thenAnswer((_) async => false);

      //act
      final result = await dataSource.saveUserToFirestore();

      //assert
      expect(result, false);
      verify(mockUserService.setUserToFirestore());
    });

    test('fail test should throw UnKnownException when user service throws exception', () async {
      //arrange
      when(mockUserService.setUserToFirestore()).thenThrow(Exception('Firestore error'));

      //act & assert
      expect(
        () => dataSource.saveUserToFirestore(),
        throwsA(isA<UnKnownException>()),
      );
    });
  });
} 