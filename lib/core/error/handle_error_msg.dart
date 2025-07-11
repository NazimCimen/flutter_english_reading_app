import 'package:flutter/foundation.dart';
import 'package:english_reading_app/core/error/failure.dart';

@immutable
final class HandleErrorMsg {
  const HandleErrorMsg._();
  static String getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.errorMessage;
      case CacheFailure:
        return failure.errorMessage;
      case ConnectionFailure:
        return failure.errorMessage;
      case UnKnownFaliure:
        return failure.errorMessage;
      default:
        return 'An unexpected error occurred';
    }
  }
}
