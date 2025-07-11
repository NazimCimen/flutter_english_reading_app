import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/login_usecase.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(repository: mockRepository);
  });

  group('success/fail test LoginUseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('success test should return Right when login succeeds', () async {
      //arrange
      when(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => const Right(null));

      //act
      final result = await useCase(
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

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(
        email: testEmail,
        password: testPassword,
      );

      // assert
      expect(result, Left(failure));
      verify(mockRepository.login(
        email: testEmail,
        password: testPassword,
      ));
    });
  });
} 