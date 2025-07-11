import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:english_reading_app/feature/auth/domain/usecase/save_user_to_firestore_usecase.dart';

import 'save_user_to_firestore_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SaveUserToFirestoreUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SaveUserToFirestoreUseCase(repository: mockRepository);
  });

  group('success/fail test SaveUserToFirestoreUseCase', () {
    test('success test', () async {
      // arrange
      when(mockRepository.saveUserToFirestore())
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(true));
      verify(mockRepository.saveUserToFirestore());
    });

    test('fail test', () async {
      // arrange
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockRepository.saveUserToFirestore())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(failure));
      verify(mockRepository.saveUserToFirestore());
    });
  });
} 