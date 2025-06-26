import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:english_reading_app/config/localization/app_languages.dart';
import 'package:english_reading_app/core/utils/enum/image_enum.dart';

@immutable
final class LocaleConstants {
  const LocaleConstants._();
  static const trLocale = Locale('tr', 'TR');
  static const enLocale = Locale('en', 'US');
  static const localePath = 'assets/lang';

  static final List<AppLanguages> languageList = [
    AppLanguages(
      name: 'Türkçe',
      locale: trLocale,
      flagName: ImageEnums.flag_turkey.toPathPng,
    ),
    AppLanguages(
      name: 'English',
      locale: enLocale,
      flagName: ImageEnums.flag_usa.toPathPng,
    ),
  ];
}
