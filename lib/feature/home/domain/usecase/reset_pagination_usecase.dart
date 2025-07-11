import 'package:english_reading_app/feature/home/domain/repository/home_repository.dart';

class ResetPaginationUseCase {
  final HomeRepository repository;
  
  ResetPaginationUseCase({required this.repository});
  
  /// Resets the pagination state to start fetching articles from the beginning.
  /// This clears any cached pagination state.
  void call() {
    repository.resetPagination();
  }
} 