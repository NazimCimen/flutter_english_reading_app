import 'package:flutter/material.dart';

@immutable
final class AppDurations {
  const AppDurations._();
  static const Duration timeoutDuration = Duration(seconds: 15);
  static const Duration smallDuration = Duration(seconds: 5);
  static const Duration loadingDuration = Duration(milliseconds: 500);
}
