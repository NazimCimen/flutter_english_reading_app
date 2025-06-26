import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

abstract class DictionaryService {
  Future<Either<Failure, List<DictionaryEntry>>> getWordDetail(String word);
}

class DictionaryServiceImpl implements DictionaryService {
  final Dio dio;

  DictionaryServiceImpl(this.dio);
  @override
  Future<Either<Failure, List<DictionaryEntry>>> getWordDetail(
    String word,
  ) async {
    try {
      final response = await dio.get<List<dynamic>>(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );

      if (response.statusCode == 200) {
        final data =
            (response.data as List)
                .cast<Map<String, dynamic>>()
                .map((json) => DictionaryEntry.fromJson(json))
                .toList();
        return right(data);
      } else {
        return left(
          ServerFailure(errorMessage: 'Sunucu hatası: ${response.statusCode}'),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure(errorMessage: 'İstek hatası: ${e.message}'));
    } catch (e) {
      return left(ServerFailure(errorMessage: 'Bilinmeyen hata: $e'));
    }
  }
}
