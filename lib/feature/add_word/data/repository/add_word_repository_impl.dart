import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/add_word/domain/repository/add_word_repository.dart';
import 'package:english_reading_app/feature/add_word/data/datasource/add_word_remote_data_source.dart';
import 'package:english_reading_app/product/services/auth_service.dart';

class AddWordRepositoryImpl implements AddWordRepository {
  final AddWordRemoteDataSource remoteDataSource;
  final AuthService authService;

  AddWordRepositoryImpl({
    required this.remoteDataSource,
    required this.authService,
  });

  @override
  Future<Either<Failure, DictionaryEntry>> saveWord(
    DictionaryEntry word,
  ) async {
    final currentUser = authService.currentUser;
    if (currentUser == null) {
      return Left(UnKnownFaliure(errorMessage: 'Kullanıcı oturum açmamış'));
    }

    final wordWithUserId = word.copyWith(userId: currentUser.uid);

    try {
      final savedWord = await remoteDataSource.saveWord(wordWithUserId);
      return Right(savedWord);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.description ?? 'Server error'));
    } on ConnectionException catch (e) {
      return Left(
        ConnectionFailure(errorMessage: e.description ?? 'Connection error'),
      );
    } on UnKnownException catch (e) {
      return Left(
        UnKnownFaliure(errorMessage: e.description ?? 'Unknown error'),
      );
    } catch (e) {
      return Left(UnKnownFaliure(errorMessage: e.toString()));
    }
  }
}
