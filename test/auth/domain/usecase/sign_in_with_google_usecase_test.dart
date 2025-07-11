import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/sign_in_with_google_usecase.dart';

import 'sign_in_with_google_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignInWithGoogleUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInWithGoogleUseCase(repository: mockRepository);
  });

  group('success/fail test SignInWithGoogleUseCase', () {
    test('success test should return Right with true for new user', () async {
      //arrange
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => const Right(true));

      //act
      final result = await useCase();

      //assert
      expect(result, const Right(true));
      verify(mockRepository.signInWithGoogle());
    });

    test('success test should return Right with false for existing user', () async {
      //arrange
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => const Right(false));

      //act
      final result = await useCase();

      //assert
      expect(result, const Right(false));
      verify(mockRepository.signInWithGoogle());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(mockRepository.signInWithGoogle());
    });
  });
} 