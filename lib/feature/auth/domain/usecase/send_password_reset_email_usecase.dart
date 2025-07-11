import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase({required this.repository});

  Future<Either<Failure, void>> call({required String email}) async {
    return repository.sendPasswordResetEmail(email: email);
  }
} 
