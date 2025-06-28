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
      case 'network-request-failed':
        return 'Ağ bağlantısı hatası. İnternet bağlantınızı kontrol edin ve tekrar deneyin.';
      case 'too-many-requests':
        return 'Çok fazla istek gönderildi. Lütfen bir süre bekleyip tekrar deneyin.';
      case 'user-token-expired':
        return 'Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.';
      case 'invalid-verification-code':
        return 'Geçersiz doğrulama kodu.';
      case 'invalid-verification-id':
        return 'Geçersiz doğrulama kimliği.';
      case 'quota-exceeded':
        return 'İstek kotası aşıldı. Lütfen daha sonra tekrar deneyin.';
      case 'app-not-authorized':
        return 'Uygulama yetkilendirilmemiş.';
      case 'keychain-error':
        return 'Anahtar zinciri hatası.';
      case 'internal-error':
        return 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
      case 'invalid-api-key':
        return 'Geçersiz API anahtarı.';
      case 'app-deleted':
        return 'Uygulama silinmiş.';
      case 'app-disabled':
        return 'Uygulama devre dışı.';
      case 'deleted-account':
        return 'Hesap silinmiş.';
      case 'invalid-user-token':
        return 'Geçersiz kullanıcı token\'ı.';
      case 'user-mismatch':
        return 'Kullanıcı uyumsuzluğu.';
      case 'credential-already-in-use':
        return 'Bu kimlik bilgisi zaten kullanımda.';
      case 'operation-cancelled':
        return 'İşlem iptal edildi.';
      case 'permission-denied':
        return 'İzin reddedildi.';
      case 'unavailable':
        return 'Hizmet şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.';
      case 'deadline-exceeded':
        return 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';
      case 'not-found':
        return 'İstenen kaynak bulunamadı.';
      case 'already-exists':
        return 'Kaynak zaten mevcut.';
      case 'resource-exhausted':
        return 'Kaynak tükenmiş.';
      case 'failed-precondition':
        return 'Ön koşul başarısız.';
      case 'aborted':
        return 'İşlem iptal edildi.';
      case 'out-of-range':
        return 'Değer aralık dışında.';
      case 'unimplemented':
        return 'İşlem henüz uygulanmamış.';
      case 'data-loss':
        return 'Veri kaybı oluştu.';
      case 'unauthenticated':
        return 'Kimlik doğrulama gerekli.';
      default:
        return 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
