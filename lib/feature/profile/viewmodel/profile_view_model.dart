import 'package:english_reading_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthServiceImpl().logout();
  }
}
