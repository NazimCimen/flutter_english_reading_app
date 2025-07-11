import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/logout_usecase.dart';

import 'logout_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(repository: mockRepository);
  });

  group('success/fail test LogoutUseCase', () {
    test('success test should return Right when logout succeeds', () async {
      //arrange
      when(mockRepository.logout()).thenAnswer((_) async => const Right(null));

      //act
      final result = await useCase();

      //assert
      expect(result, const Right(null));
      verify(mockRepository.logout());
    });

    test('fail test', () async {
      // arrange
      final failure = UnKnownFaliure(errorMessage: 'Logout error');
      when(mockRepository.logout()).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(mockRepository.logout());
    });
  });
} 