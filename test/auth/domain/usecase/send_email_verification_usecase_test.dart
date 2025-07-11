import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/send_email_verification_usecase.dart';

import 'send_email_verification_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SendEmailVerificationUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SendEmailVerificationUseCase(repository: mockRepository);
  });

  group('success/fail test SendEmailVerificationUseCase', () {
    test('success test should return Right when send email verification succeeds', () async {
      //arrange
      when(mockRepository.sendEmailVerification()).thenAnswer((_) async => const Right(null));

      //act
      final result = await useCase();

      //assert
      expect(result, const Right(null));
      verify(mockRepository.sendEmailVerification());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.sendEmailVerification()).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(mockRepository.sendEmailVerification());
    });
  });
} 