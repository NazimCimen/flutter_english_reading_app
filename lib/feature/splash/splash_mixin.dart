import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/feature/splash/data/datasource/version_local_data_source.dart';
import 'package:english_reading_app/feature/splash/data/datasource/version_remote_data_source.dart';
import 'package:english_reading_app/feature/splash/data/repository/version_repository.dart';
import 'package:english_reading_app/feature/splash/data/repository/version_repository_impl.dart';
import 'package:english_reading_app/feature/splash/data/service/version_check_service.dart';
import 'package:english_reading_app/feature/splash/splash_view.dart';
import 'package:english_reading_app/product/widgets/force_update_dialog.dart';
import 'package:english_reading_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

mixin SplashMixin on State<SplashView> {
  late final AuthService _authService;
  late final VersionCheckService _versionCheckService;
  late final VersionRepository _versionRepository;

  @override
  void initState() {
    _authService = AuthServiceImpl();
    _versionCheckService = VersionCheckService();
    
    // Repository dependency injection
    final networkInfo = NetworkInfo(InternetConnectionChecker());
    final remoteDataSource = VersionRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
    final localDataSource = VersionLocalDataSourceImpl();
    _versionRepository = VersionRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkVersionAndNavigate();
    });
    super.initState();
  }

  Future<void> _checkVersionAndNavigate() async {
    // Önce version kontrolü yap
    final versionResult = await _versionRepository.getVersionInfo();
    
    versionResult.fold(
      (failure) async {
        // Version kontrolü başarısız olursa normal akışa devam et
        print('Version check failed: ${failure.errorMessage}');
        await _navigateUser();
      },
      (versionModel) async {
        final currentVersion = await _versionCheckService.getCurrentAppVersion();
        final requiredVersion = _versionCheckService.getRequiredVersionForPlatform(
          androidVersion: versionModel.androidVersion,
          iosVersion: versionModel.iosVersion,
        );
        
        final isUpdateRequired = _versionCheckService.isUpdateRequired(
          currentVersion: currentVersion,
          requiredVersion: requiredVersion,
        );

        if (isUpdateRequired) {
          // Güncelleme gerekli
          if (mounted) {
            final shouldUpdate = await showDialog<bool>(
              context: context,
              barrierDismissible: !versionModel.forceUpdate,
              builder: (context) => ForceUpdateDialog(
                message: versionModel.updateMessage,
                updateUrl: versionModel.updateUrl,
                isForceUpdate: versionModel.forceUpdate,
              ),
            );

            if (shouldUpdate == true || versionModel.forceUpdate) {
              // Kullanıcı güncellemeyi kabul etti veya force update
              return; // Uygulamayı kapat
            } else {
              // Kullanıcı güncellemeyi reddetti (sadece force update değilse)
              await _navigateUser();
            }
          }
        } else {
          // Güncelleme gerekmiyor, normal akışa devam et
          await _navigateUser();
        }
      },
    );
  }

  Future<void> _navigateUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.navBarView);
    } else {
      await _authService.logout();
      await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginView);
    }
  }
}
