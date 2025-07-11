import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/profile/domain/repository/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String imageUrl,
  }) async {
    return repository.updateProfileImage(
      imageUrl: imageUrl,
    );
  }
} 