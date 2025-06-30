import 'dart:async';
import 'dart:io';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/error/handle_firebase_auth_error.dart';
import 'package:english_reading_app/feature/auth/mail_verificaiton/mail_verification_view.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/product/constants/app_durations.dart';
import 'package:english_reading_app/services/auth_service.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin MailVerificationMixin on State<MailVerificationView> {
  Timer? _timer;
  bool isEmailVerified = false;
  bool isResendRequestAvailable = false;
  bool isCheckingEmail = false;
  int retryCount = 0;
  static const int maxRetryCount = 3;
  final UserService _userService = UserService();
  final AuthService _authService = AuthServiceImpl();
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    checkEmailVerified();
    super.initState();
  }

  Future<void> checkEmailVerified() async {
    if (isCheckingEmail) return;
    
    setState(() {
      isCheckingEmail = true;
    });

    final result = await _authService.checkEmailVerification();
    result.fold(
      (failure) {
        setState(() {
          isCheckingEmail = false;
        });
        
        // Network error durumunda retry mekanizması
        if (failure.errorMessage == 'network-request-failed' && retryCount < maxRetryCount) {
          _handleNetworkErrorWithRetry();
        } else {
          CustomSnackBars.showCustomBottomScaffoldSnackBar(
            context: context,
            text: HandleFirebaseAuthError.convertErrorMsg(
              errorCode: failure.errorMessage ?? 'Bilinmeyen hata',
            ),
          );
          _startEmailCheckTimer();
        }
      },
      (isVerified) {
        setState(() {
          isEmailVerified = isVerified;
          isCheckingEmail = false;
          retryCount = 0; // Başarılı olursa retry count'u sıfırla
        });
        
        if (isVerified) {
          _timer?.cancel();
          _handleEmailVerified();
        } else {
          // Email henüz doğrulanmamışsa timer'ı başlat
          _startEmailCheckTimer();
        }
      },
    );
  }

  Future<void> _handleEmailVerified() async {
    await Future.delayed(AppDurations.smallDuration, () async {
      final result = await _userService.setUserToFirestore();
      if (result) {
        await NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.navBarView,
        );
      } else {
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: 'Bir sorun oluştu daha sonra tekrar deneyiniz',
        );
      }
    });
  }

  void _handleNetworkErrorWithRetry() {
    if (retryCount < maxRetryCount) {
      retryCount++;
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: 'Ağ bağlantısı hatası. ${retryCount}. deneme...',
      );
      
      // 5 saniye sonra tekrar dene
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          checkEmailVerified();
        }
      });
    } else {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: 'Ağ bağlantısı sorunu devam ediyor. Lütfen internet bağlantınızı kontrol edin.',
      );
      _startEmailCheckTimer();
    }
  }

  void _startEmailCheckTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        if (!isCheckingEmail && mounted) {
          checkEmailVerified();
        }
      },
    );
  }

  Future<void> resendEmailVerification() async {
    if (isResendRequestAvailable) return;
    
    setState(() {
      isResendRequestAvailable = true;
    });

    final result = await _authService.sendEmailVerification();
    result.fold(
      (failure) {
        setState(() {
          isResendRequestAvailable = false;
        });
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: HandleFirebaseAuthError.convertErrorMsg(
            errorCode: failure.errorMessage ?? 'Bilinmeyen hata',
          ),
        );
      },
      (success) {
        setState(() {
          isResendRequestAvailable = false;
        });
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: 'Doğrulama e-postası tekrar gönderildi',
        );
      },
    );
  }
}
