import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/check_email_verification_usecase.dart';

import 'check_email_verification_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late CheckEmailVerificationUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = CheckEmailVerificationUseCase(repository: mockRepository);
  });

  group('success/fail test CheckEmailVerificationUseCase', () {
    test('success test should return Right with true when email is verified', () async {
      //arrange
      when(mockRepository.checkEmailVerification()).thenAnswer((_) async => const Right(true));

      //act
      final result = await useCase();

      //assert
      expect(result, const Right(true));
      verify(mockRepository.checkEmailVerification());
    });

    test('success test should return Right with false when email is not verified', () async {
      //arrange
      when(mockRepository.checkEmailVerification()).thenAnswer((_) async => const Right(false));

      //act
      final result = await useCase();

      //assert
      expect(result, const Right(false));
      verify(mockRepository.checkEmailVerification());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.checkEmailVerification())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(mockRepository.checkEmailVerification());
    });
  });
} 