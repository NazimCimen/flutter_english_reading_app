import 'package:flutter/material.dart';

@immutable
final class HandleFirebaseAuthError {
  static String convertErrorMsg({required String errorCode}) {
    switch (errorCode) {
      case 'invalid-email':
        return 'Geçersiz bir e-posta adresi girdiniz.';
      case 'user-not-found':
        return 'Bu e-posta adresine kayıtlı bir kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Hatalı bir şifre girdiniz. Lütfen tekrar deneyin.';
      case 'email-already-in-use':
        return 'Bu e-posta adresiyle zaten bir hesap oluşturulmuş.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış. Lütfen destek ile iletişime geçin.';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda devre dışı. Lütfen destek ile iletişime geçin.';
      case 'weak-password':
        return 'Girilen şifre çok zayıf. Daha güçlü bir şifre seçin.';
      case 'account-exists-with-different-credential':
        return 'Bu e-posta adresiyle farklı bir kimlik doğrulama yöntemi kullanılıyor.';
      case 'invalid-credential':
        return 'Geçersiz bir kimlik doğrulama bilgisi sağlandı.';
      case 'requires-recent-login':
        return 'Bu işlemi yapmak için tekrar oturum açmanız gerekiyor.';
      default:
        return 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
