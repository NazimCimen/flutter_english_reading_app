import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/signup_usecase.dart';

import 'signup_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignupUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignupUseCase(repository: mockRepository);
  });

  group('success/fail test SignupUseCase', () {
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
      final result = await useCase(
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

    test('fail test', () async {
      // arrange
      const testEmail = 'test@example.com';
      const testPassword = 'password123';
      const testName = 'Test User';
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      )).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      // assert
      expect(result, Left(failure));
      verify(mockRepository.signup(
        email: testEmail,
        password: testPassword,
        name: testName,
      ));
    });
  });
} 