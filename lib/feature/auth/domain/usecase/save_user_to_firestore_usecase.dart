import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';

class SaveUserToFirestoreUseCase {
  final AuthRepository repository;

  SaveUserToFirestoreUseCase({required this.repository});

  /// Saves current authenticated user to Firestore.
  /// Returns true if successful, false otherwise.
  Future<Either<Failure, bool>> call() async {
    return await repository.saveUserToFirestore();
  }
} 