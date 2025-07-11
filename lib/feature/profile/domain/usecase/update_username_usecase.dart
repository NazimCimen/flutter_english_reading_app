import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/profile/domain/repository/profile_repository.dart';

class UpdateUsernameUseCase {
  final ProfileRepository repository;

  UpdateUsernameUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String newUsername,
  }) async {
    return repository.updateUsername(
      newUsername: newUsername,
    );
  }
} 