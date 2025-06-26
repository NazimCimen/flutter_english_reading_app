import 'dart:async';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/feature/auth/mail_verificaiton/mail_verification_view.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/product/constants/app_durations.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

mixin MailVerificationMixin on State<MailVerificationView> {
  Timer? _timer;
  bool isEmailVerified = false;
  final UserService _userService = UserService();
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
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        await FirebaseAuth.instance.currentUser!.reload();
        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });
        if (isEmailVerified) {
          await Future.delayed(AppDurations.smallDuration, () async {
            _timer?.cancel();

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
              //TODO: Burada bir hata oluştuğunda ne yapılacağına karar verilecek.
            }
          });
        } else {}
      },
    );
  }
}
