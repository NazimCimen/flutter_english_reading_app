import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository repository;

  SendEmailVerificationUseCase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return repository.sendEmailVerification();
  }
} 
