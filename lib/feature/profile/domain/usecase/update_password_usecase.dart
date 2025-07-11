import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/profile/domain/repository/profile_repository.dart';

class UpdatePasswordUseCase {
  final ProfileRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return repository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
} 