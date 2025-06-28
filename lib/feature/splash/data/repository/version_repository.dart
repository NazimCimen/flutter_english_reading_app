import 'package:dartz/dartz.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/product/model/version_model.dart';

abstract class VersionRepository {
  Future<Either<Failure, VersionModel>> getVersionInfo();
} 