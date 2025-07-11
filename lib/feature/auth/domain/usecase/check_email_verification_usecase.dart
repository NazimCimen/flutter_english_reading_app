import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';

class CheckEmailVerificationUseCase {
  final AuthRepository repository;

  CheckEmailVerificationUseCase({required this.repository});

  Future<Either<Failure, bool>> call() async {
    return repository.checkEmailVerification();
  }
} 
