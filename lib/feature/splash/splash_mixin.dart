import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/cache/cache_enum.dart';
import 'package:english_reading_app/core/cache/cache_manager/base_cache_manager.dart';
import 'package:english_reading_app/core/cache/cache_manager/standart_cache_manager.dart';
import 'package:english_reading_app/feature/splash/splash_view.dart';
import 'package:english_reading_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

mixin SplashMixin on State<SplashView> {
  late final AuthService _authService;
  late final BaseCacheManager<bool> cacheManager;

  @override
  void initState() {
    _authService = AuthServiceImpl();
    cacheManager = StandartCacheManager<bool>(
      boxName: CacheHiveBoxEnum.appSettings.name,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _navigateUser();
    });

    super.initState();
  }

  Future<void> _navigateUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.mainLayoutView);
    } else {
      await _authService.logout();

      final onboardShown = await _getOnboardVisibility();

      if (onboardShown) {
        await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginView);
      } else {
        await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.onboardView);
      }
    }
  }

  Future<bool> _getOnboardVisibility() async {
    final onboardShown = await cacheManager.getData(
      keyName: CacheKeyEnum.onboardVisibility.name,
    );
    return onboardShown ?? false;
  }
}
