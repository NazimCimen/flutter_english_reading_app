import 'package:flutter/material.dart';

@immutable
final class StringConstants {
  static String get appName => 'LINGZY';
  
  // Auth Başlıkları ve Alt Başlıkları - English Reading App'e uygun
  static String get loginTitle => 'Tekrar Hoş Geldin!';
  static String get loginSubtitle =>
      'İngilizce öğrenme yolculuğuna devam etmek için giriş yap.';
  static String get emailLabel => 'E-posta';
  static String get passwordLabel => 'Şifre';
  static String get forgotPassword => 'Şifremi Unuttum?';
  static String get loginButton => 'Giriş Yap';
  static String get loginWithGoogle => 'Google İle Giriş Yap';
  static String get noAccount => 'Henüz hesabın yok mu? ';
  static String get signUp => 'Kayıt Ol';
  
  static String get signUpTitle => 'İngilizce Yolculuğun Başlasın!';
  static String get signUpSubtitle =>
      'Kişiselleştirilmiş öğrenme deneyimin için hesap oluştur.';
  static String get nameLabel => 'İsim Soyisim';
  static String get termsAgreement => 'Kullanım Şartlarını';
  static String get termsAcceptance => ' okudum ve kabul ediyorum.';
  static String get signUpButton => 'Hesap Oluştur';
  static String get signUpWithGoogle => 'Google İle Başla';
  static String get alreadyHaveAccount => 'Zaten hesabın var mı? ';
  static String get login => 'Giriş Yap';
  
  // E-posta Doğrulama
  static String get verifyEmail => 'E-posta adresini doğrula';
  static String get resendMailVerification =>
      'Doğrulama E-postasını Tekrar Gönder';
  static String get mailVerified =>
      'E-posta adresin doğrulandı! Ana sayfaya yönlendiriliyorsun...';
  static String get send => 'Gönder';
  
  // Şifre Sıfırlama
  static String get enterMailForRefresh =>
      'Şifreni sıfırlamak için e-posta adresini gir';
  static String get refreshPassword => 'Şifre Yenileme';
  static String get afterRefreshMail =>
      'Şifre sıfırlama bağlantısı e-posta adresine gönderildi. Gelen kutunu kontrol et!';

  // Auth Mesajları - UX Odaklı, Dil Tutarlı
  static String get accountCreatedButProfileFailed =>
      'Hesabın oluşturuldu! Profil kurulumu tamamlanamadı, giriş yaparak devam edebilirsin.';
  static String get continueWithoutAccount => 'Hesap açmadan keşfet';
  static String get continuing => 'Yönlendiriliyor...';
  static String get successfullySignedIn => 'Başarıyla giriş yaptın! Öğrenmeye devam et.';
  static String get pleaseAcceptTerms => 'Devam etmek için kullanım şartlarını kabul etmen gerekiyor.';

  // Firebase Auth Hata Mesajları - Kullanıcı Dostu
  static String get invalidEmail => 'Geçersiz e-posta adresi girdin.';
  static String get invalidRecipientEmail =>
      'E-posta gönderilemedi. Geçerli bir e-posta adresi gir.';
  static String get userNotFound =>
      'Bu e-posta adresine kayıtlı hesap bulunamadı.';
  static String get wrongPassword =>
      'Hatalı şifre girdin. Tekrar dene.';
  static String get emailAlreadyInUse =>
      'Bu e-posta adresiyle zaten hesap oluşturulmuş.';
  static String get userDisabled =>
      'Hesabın geçici olarak devre dışı. Destek ekibimizle iletişime geç.';
  static String get operationNotAllowed =>
      'Bu işlem şu anda kullanılamıyor. Destek ekibimizle iletişime geç.';
  static String get weakPassword =>
      'Şifren çok zayıf. Daha güçlü bir şifre seç.';
  static String get accountExistsWithDifferentCredential =>
      'Bu e-posta adresiyle farklı bir giriş yöntemi kullanılıyor.';
  static String get invalidCredential =>
      'Giriş bilgilerin geçersiz.';
  static String get requiresRecentLogin =>
      'Bu işlem için tekrar giriş yapman gerekiyor.';
  static String get networkRequestFailed =>
      'İnternet bağlantın yok. Bağlantını kontrol edip tekrar dene.';
  static String get tooManyRequests =>
      'Çok fazla deneme yaptın. Biraz bekleyip tekrar dene.';
  static String get userTokenExpired =>
      'Oturum süresi dolmuş. Tekrar giriş yap.';
  static String get invalidVerificationCode => 'Geçersiz doğrulama kodu.';
  static String get invalidVerificationId => 'Geçersiz doğrulama kimliği.';
  static String get quotaExceeded =>
      'Çok fazla istek gönderildi. Daha sonra tekrar dene.';
  static String get appNotAuthorized => 'Uygulama yetkilendirilmemiş.';
  static String get keychainError => 'Güvenlik anahtarı hatası.';
  static String get internalError =>
      'Sunucu hatası. Daha sonra tekrar dene.';
  static String get invalidApiKey => 'Geçersiz API anahtarı.';
  static String get appDeleted => 'Uygulama silinmiş.';
  static String get appDisabled => 'Uygulama devre dışı.';
  static String get deletedAccount => 'Hesap silinmiş.';
  static String get invalidUserToken => 'Geçersiz kullanıcı token\'ı.';
  static String get userMismatch => 'Kullanıcı uyumsuzluğu.';
  static String get credentialAlreadyInUse => 'Bu kimlik bilgisi zaten kullanımda.';
  static String get operationCancelled => 'İşlem iptal edildi.';
  static String get permissionDenied => 'İzin reddedildi.';
  static String get unavailable =>
      'Hizmet şu anda kullanılamıyor. Daha sonra tekrar dene.';
  static String get deadlineExceeded =>
      'İstek zaman aşımına uğradı. Tekrar dene.';
  static String get notFound => 'İstenen kaynak bulunamadı.';
  static String get alreadyExists => 'Kaynak zaten mevcut.';
  static String get resourceExhausted => 'Kaynak tükenmiş.';
  static String get failedPrecondition => 'Ön koşul başarısız.';
  static String get aborted => 'İşlem iptal edildi.';
  static String get outOfRange => 'Değer aralık dışında.';
  static String get unimplemented => 'İşlem henüz uygulanmamış.';
  static String get dataLoss => 'Veri kaybı oluştu.';
  static String get unauthenticated => 'Giriş yapman gerekiyor.';
  static String get unexpectedError =>
      'Beklenmeyen bir hata oluştu. Tekrar dene.';

  // Home Feature Mesajları
  static String get homeGreeting => 'Merhaba';
  static String get welcomeToLingzy => 'Lingzy\'e Hoş Geldin!';
  static String get noArticlesFound => 'Henüz makale bulunamadı';
  static String get loadMoreContent => 'Daha fazla içerik için kategorileri keşfet!';
  static String get needAccountToSave => 'Makale kaydetmek için hesap oluşturman gerekiyor.';
  static String get needEmailVerificationToSave => 'Makale kaydetmek için e-posta adresini doğrulaman gerekiyor.';
  static String get articleRemovedFromSaved => 'Makale kaydedilenlerden kaldırıldı.';
  static String get articleSavedSuccessfully => 'Makale başarıyla kaydedildi!';
  static String get somethingWentWrong => 'Bir şeyler ters gitti. Lütfen daha sonra tekrar dene.';
  static String get refreshToLoadMore => 'Yenilemek için aşağı çek';
}
