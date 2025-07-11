import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';

abstract class ProfileRepository {
  Future<Either<Failure, bool>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> updateUsername({
    required String newUsername,
  });

  Future<Either<Failure, bool>> updateProfileImage({
    required String imageUrl,
  });

  Future<Either<Failure, bool>> logout();
} 