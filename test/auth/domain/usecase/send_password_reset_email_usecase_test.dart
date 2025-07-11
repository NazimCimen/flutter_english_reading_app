import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/send_password_reset_email_usecase.dart';

import 'send_password_reset_email_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SendPasswordResetEmailUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SendPasswordResetEmailUseCase(repository: mockRepository);
  });

  group('success/fail test SendPasswordResetEmailUseCase', () {
    const testEmail = 'test@example.com';

    test('success test should return Right when send password reset email succeeds', () async {
      //arrange
      when(mockRepository.sendPasswordResetEmail(email: testEmail))
          .thenAnswer((_) async => const Right(null));

      //act
      final result = await useCase(email: testEmail);

      //assert
      expect(result, const Right(null));
      verify(mockRepository.sendPasswordResetEmail(email: testEmail));
    });

    test('fail test', () async {
      // arrange
      const testEmail = 'test@example.com';
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.sendPasswordResetEmail(email: testEmail))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(email: testEmail);

      // assert
      expect(result, Left(failure));
      verify(mockRepository.sendPasswordResetEmail(email: testEmail));
    });
  });
} 