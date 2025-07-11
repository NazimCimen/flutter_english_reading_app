import 'dart:io';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/services/auth_service.dart';
import 'package:english_reading_app/product/services/user_service_export.dart';

abstract class ProfileRemoteDataSource {
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<bool> updateUsername({
    required String newUsername,
  });

  Future<String?> uploadProfileImage({
    required File imageFile,
  });

  Future<bool> updateProfileImage({
    required String imageUrl,
  });

  Future<bool> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final UserService _userService = UserServiceImpl();
  final AuthService _authService = AuthServiceImpl();

  @override
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Re-authenticate user with current password
      final isOldCorrect = await _userService.reAuthenticateUser(
        currentPassword: currentPassword,
      );
      
      if (!isOldCorrect) {
        throw ServerException('The old password is incorrect');
      }

      // Update password
      final success = await _userService.updatePassword(
        newPassword: newPassword,
      );

      if (!success) {
        throw ServerException('Failed to update password');
      }

      return success;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw UnKnownException('Error updating password: $e');
    }
  }

  @override
  Future<bool> updateUsername({
    required String newUsername,
  }) async {
    try {
      final userId = _userService.getUserId();
      if (userId == null) {
        throw ServerException('User not found');
      }

      final currentUser = await _userService.getUserById(userId: userId);
      if (currentUser == null) {
        throw ServerException('User not found');
      }

      final updatedUser = currentUser.copyWith(
        nameSurname: newUsername,
      );

      final success = await _userService.updateUser(updatedUser);

      if (!success) {
        throw ServerException('Failed to update username');
      }

      return success;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw UnKnownException('Error updating username: $e');
    }
  }

  @override
  Future<String?> uploadProfileImage({
    required File imageFile,
  }) async {
    try {
      final imageUrl = await _userService.uploadProfileImage(imageFile: imageFile);
      return imageUrl;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw UnKnownException('Error uploading profile image: $e');
    }
  }

  @override
  Future<bool> updateProfileImage({
    required String imageUrl,
  }) async {
    try {
      final success = await _userService.updateProfileImage(imageUrl: imageUrl);
      
      if (!success) {
        throw ServerException('Failed to update profile image');
      }

      return success;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw UnKnownException('Error updating profile image: $e');
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _authService.logout();
      return true;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw UnKnownException('Error during logout: $e');
    }
  }
} 