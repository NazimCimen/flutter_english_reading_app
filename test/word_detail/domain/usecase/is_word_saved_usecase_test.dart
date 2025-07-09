// ignore_for_file: inference_failure_on_instance_creation
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/is_word_saved_usecase.dart';

import 'is_word_saved_usecase_test.mocks.dart';

@GenerateMocks([WordDetailRepository])
void main() {
  late IsWordSavedUseCase useCase;
  late MockWordDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockWordDetailRepository();
    useCase = IsWordSavedUseCase(mockRepository);
  });

  const tWord = 'test';
  const tUserId = 'userId';

  group('success test is word saved', () {
    test('success test should return true when word is saved', () async {
      // arrange
      when(mockRepository.isWordSaved(tWord, tUserId))
          .thenAnswer((_) async => const Right(true));
      // act
      final result = await useCase(tWord, tUserId);
      // assert
      expect(result, const Right(true));
      verify(mockRepository.isWordSaved(tWord, tUserId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should return false when word is not saved', () async {
      // arrange
      when(mockRepository.isWordSaved(tWord, tUserId))
          .thenAnswer((_) async => const Right(false));
      // act
      final result = await useCase(tWord, tUserId);
      // assert
      expect(result, const Right(false));
      verify(mockRepository.isWordSaved(tWord, tUserId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('fail test is word saved', () {
    test('fail test should return failure when repository call fails', () async {
      // arrange
      when(mockRepository.isWordSaved(tWord, tUserId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));
      // act
      final result = await useCase(tWord, tUserId);
      // assert
      expect(result, isA<Left<Failure, bool>>());
      verify(mockRepository.isWordSaved(tWord, tUserId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('fail test should return failure when word is empty', () async {
      // arrange
      const emptyWord = '';
      // act
      final result = await useCase(emptyWord, tUserId);
      // assert
      expect(result, isA<Left<Failure, bool>>());
      verifyZeroInteractions(mockRepository);
    });

    test('fail test should return failure when userId is empty', () async {
      // arrange
      const emptyUserId = '';
      // act
      final result = await useCase(tWord, emptyUserId);
      // assert
      expect(result, isA<Left<Failure, bool>>());
      verifyZeroInteractions(mockRepository);
    });
  });
} 