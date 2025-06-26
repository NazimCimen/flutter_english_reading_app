import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/feature/splash/splash_view.dart';
import 'package:english_reading_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

mixin SplashMixin on State<SplashView> {
  late final AuthService _service;

  @override
  void initState() {
    _service = AuthService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _navigateUser();
    });
    super.initState();
  }

  Future<void> _navigateUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.navBarView);
    } else {
      await _service.logout();
      await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginView);
    }
  }
}
