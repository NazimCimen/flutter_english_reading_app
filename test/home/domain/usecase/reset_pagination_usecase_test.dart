import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/feature/home/domain/repository/home_repository.dart';
import 'package:english_reading_app/feature/home/domain/usecase/reset_pagination_usecase.dart';

import 'reset_pagination_usecase_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late ResetPaginationUseCase useCase;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = ResetPaginationUseCase(repository: mockRepository);
  });

  group('success/fail test ResetPaginationUseCase', () {
    test('success test should call resetPagination on repository', () {
      //arrange
      when(mockRepository.resetPagination()).thenReturn(null);

      //act
      useCase.call();

      //assert
      verify(mockRepository.resetPagination());
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should execute without throwing exception', () {
      //arrange
      when(mockRepository.resetPagination()).thenReturn(null);

      //act & assert
      expect(() => useCase.call(), returnsNormally);
      verify(mockRepository.resetPagination());
      verifyNoMoreInteractions(mockRepository);
    });

    test('success test should handle multiple calls correctly', () {
      //arrange
      when(mockRepository.resetPagination()).thenReturn(null);

      //act
      useCase.call();
      useCase.call();
      useCase.call();

      //assert
      verify(mockRepository.resetPagination()).called(3);
      verifyNoMoreInteractions(mockRepository);
    });
  });
} 