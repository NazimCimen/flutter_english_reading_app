import 'package:english_reading_app/product/model/user_model.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainLayoutViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  final _userService = UserService();
  UserModel? _user;
  UserModel? get user => _user;
  bool isLoading = false;

  Future<void> loadUser() async {
    setIsLoading(true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final model = await _userService.getUserById(userId: uid);
    _user = model;
    setIsLoading(false);
  }



  void setTabIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
