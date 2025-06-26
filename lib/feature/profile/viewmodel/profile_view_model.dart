import 'package:english_reading_app/core/cache/cache_enum.dart';
import 'package:english_reading_app/core/cache/cache_manager/standart_cache_manager.dart';
import 'package:english_reading_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {


  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }


   Future<void> logout() async {
    await StandartCacheManager<String>(
      boxName: CacheHiveBoxEnum.authBox.name,
    ).clearData(keyName: CacheKeyEnum.authRememberMe.name);
    await AuthService().logout();
  }
}
