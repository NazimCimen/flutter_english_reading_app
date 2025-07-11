import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/auth/domain/repository/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return repository.signup(
      email: email,
      password: password,
      name: name,
    );
  }
} 
