import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';

class DeleteWordFromBankUseCase {
  final WordBankRepository repository;

  DeleteWordFromBankUseCase({required this.repository});

  Future<Either<Failure, void>> call(String documentId) async {
    // Business logic validation
    if (documentId.isEmpty) {
      return Left(InputNoImageFailure(errorMessage: 'Kelime ID\'si boş olamaz'));
    }

    return await repository.deleteWord(documentId);
  }
} 