import 'dart:io';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/logout_usecase.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/update_password_usecase.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/update_profile_image_usecase.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/update_username_usecase.dart';
import 'package:english_reading_app/product/services/user_service.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final UpdateUsernameUseCase _updateUsernameUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;
  final LogoutUseCase _logoutUseCase;
  final UserService _userService;

  ProfileViewModel({
    required UpdatePasswordUseCase updatePasswordUseCase,
    required UpdateUsernameUseCase updateUsernameUseCase,
    required UpdateProfileImageUseCase updateProfileImageUseCase,
    required LogoutUseCase logoutUseCase,
    required UserService userService,
  })  : _updatePasswordUseCase = updatePasswordUseCase,
        _updateUsernameUseCase = updateUsernameUseCase,
        _updateProfileImageUseCase = updateProfileImageUseCase,
        _logoutUseCase = logoutUseCase,
        _userService = userService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setSuccess(String? message) {
    _successMessage = message;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Update user password
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    final result = await _updatePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (success) {
        if (success) {
          _setSuccess('Password updated successfully');
        } else {
          _setError('Failed to update password');
        }
      },
    );

    _setLoading(false);
  }

  /// Update user username
  Future<void> updateUsername({
    required String newUsername,
  }) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    final result = await _updateUsernameUseCase(
      newUsername: newUsername,
    );

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (success) {
        if (success) {
          _setSuccess('Username updated successfully');
        } else {
          _setError('Failed to update username');
        }
      },
    );

    _setLoading(false);
  }

  /// Update profile image
  Future<void> updateProfileImage({
    required String imageUrl,
  }) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    final result = await _updateProfileImageUseCase(
      imageUrl: imageUrl,
    );

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (success) {
        if (success) {
          _setSuccess('Profile image updated successfully');
        } else {
          _setError('Failed to update profile image');
        }
      },
    );

    _setLoading(false);
  }

  /// Upload profile image and update profile
  Future<void> uploadAndUpdateProfileImage({
    required File imageFile,
  }) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    try {
      // Upload image to Cloud Storage
      final imageUrl = await _userService.uploadProfileImage(imageFile: imageFile);
      
      if (imageUrl == null) {
        _setError('Error occurred while uploading profile image.');
        _setLoading(false);
        return;
      }

      // Update profile image using usecase
      final result = await _updateProfileImageUseCase(imageUrl: imageUrl);

      result.fold(
        (failure) {
          _setError(_getErrorMessage(failure));
        },
        (success) {
          if (success) {
            _setSuccess('Profile image updated successfully');
          } else {
            _setError('Failed to update profile image');
          }
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    }

    _setLoading(false);
  }

  /// Logout user
  Future<void> logout() async {
    _setLoading(true);
    _setError(null);

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (success) {
        // Logout successful, no need to show success message
      },
    );

    _setLoading(false);
  }

  /// Reset ProfileViewModel when user logs out
  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.errorMessage;
      case CacheFailure:
        return failure.errorMessage;
      case ConnectionFailure:
        return failure.errorMessage;
      case UnKnownFaliure:
        return failure.errorMessage;
      default:
        return 'An unexpected error occurred';
    }
  }
}
