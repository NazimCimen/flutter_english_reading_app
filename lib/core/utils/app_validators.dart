import 'package:flutter/foundation.dart';

@immutable
final class AppValidators {
  const AppValidators._();

  static const String emailRegExp =
      r'^[^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*|(\".+\")@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String passwordRegExp =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
  static const String nameRegExp = r'^[a-zA-ZığüşöçİĞÜŞÖÇ ]{2,50}$';

  // İsim Soyisim Validator
  static String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'İsim ve soyisim boş olamaz.';
    }
    if (!RegExp(nameRegExp).hasMatch(value)) {
      return 'İsim ve soyisim yalnızca harfler içerebilir ve 2-50 karakter uzunluğunda olmalıdır.';
    }
    return null;
  }

  // E-posta Validator
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi boş olamaz.';
    }
    if (!RegExp(emailRegExp).hasMatch(value)) {
      return 'Geçerli bir e-posta adresi giriniz.';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi giriniz';
    } else if (value.length < 6) {
      return 'Şifreniz en az 6 karakter olmalıdır';
    } else {
      return null;
    }
  }
}
