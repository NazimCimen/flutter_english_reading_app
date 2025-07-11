import 'package:english_reading_app/feature/home/domain/repository/home_repository.dart';

class ResetPaginationUseCase {
  final HomeRepository repository;
  
  ResetPaginationUseCase({required this.repository});
  
  void call() {
    repository.resetPagination();
  }
} 