import 'package:english_reading_app/product/model/user_model.dart';
import 'package:english_reading_app/product/services/user_service_export.dart';
import 'package:english_reading_app/product/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainLayoutViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  final _userService = UserServiceImpl();
  final _authService = AuthServiceImpl();
  UserModel? _user;
  UserModel? get user => _user;
  bool isLoading = false;
  bool _isMailVerified = false;
  bool get isMailVerified => _isMailVerified;
  
  // Check if user has an account (is authenticated)
  bool get hasAccount => FirebaseAuth.instance.currentUser != null;

  Future<void> loadUser() async {
    setIsLoading(true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      
      final model = await _userService.getUserById(userId: uid);
      _user = model;
      
      // Check email verification status
      await checkEmailVerification();
    } catch (e) {
      // Handle any exceptions during user loading
      _user = null;
      _isMailVerified = false;
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      final result = await _authService.checkEmailVerification();
      result.fold(
        (failure) {
          _isMailVerified = false;
        },
        (isVerified) {
          _isMailVerified = isVerified;
        },
      );
    } catch (e) {
      // Handle any unexpected exceptions
      _isMailVerified = false;
    }
    notifyListeners();
  }

  Future<bool> sendEmailVerification() async {
    try {
      final result = await _authService.sendEmailVerification();
      return result.fold(
        (failure) => false,
        (success) => true,
      );
    } catch (e) {
      // Handle any unexpected exceptions
      return false;
    }
  }

  void setTabIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Reset all viewmodels when user logs out
  void resetAllViewModels() {
    // Reset MainLayoutViewModel state
    _currentIndex = 0;
    _user = null;
    isLoading = false;
    _isMailVerified = false;
    
    // Notify listeners to update UI
    notifyListeners();
  }
}
