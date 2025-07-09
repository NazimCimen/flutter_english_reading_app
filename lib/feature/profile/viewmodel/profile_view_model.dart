import 'package:english_reading_app/product/services/auth_service.dart';
import 'package:english_reading_app/product/services/user_service_export.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserService _userService = UserServiceImpl();
  
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthServiceImpl().logout();
  }

  /// Reset ProfileViewModel when user logs out
  void reset() {
    isLoading = false;
    notifyListeners();
  }

  /// Update user password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    setLoading(true);
    
    try {
      // Re-authenticate user with current password
      final isOldCorrect = await _userService.reAuthenticateUser(
        currentPassword: currentPassword,
      );
      
      if (!isOldCorrect) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The old password is incorrect'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setLoading(false);
        return false;
      }

      // Update password
      final success = await _userService.updatePassword(
        newPassword: newPassword,
      );

      if (success && context.mounted) {
        // Refresh user data
        await context.read<MainLayoutViewModel>().loadUser();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      setLoading(false);
      return success;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating password: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  /// Update user username
  Future<bool> updateUsername({
    required String newUsername,
    required BuildContext context,
  }) async {
    setLoading(true);
    
    try {
      final currentUser = context.read<MainLayoutViewModel>().user;
      if (currentUser == null) {
        setLoading(false);
        return false;
      }

      final updatedUser = currentUser.copyWith(
        nameSurname: newUsername,
      );

      final success = await _userService.updateUser(updatedUser);

      if (success && context.mounted) {
        // Refresh user data
        await context.read<MainLayoutViewModel>().loadUser();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      setLoading(false);
      return success;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating username: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }
}
