import 'package:english_reading_app/product/model/user_model.dart';
import 'dart:io';

/// TODO: Add internet connection check
abstract class UserService {

  /// Returns true if user is currently signed in, false otherwise
  bool isUserSignIn();
  
  /// Returns the current user's ID if signed in, null otherwise
  String? getUserId();
  
  /// Returns user document by ID
  Future<UserModel?> getUserById({required String? userId});
  
  /// Saves user to Firestore
  Future<bool> setUserToFirestore();
  
  /// Updates user information
  Future<bool> updateUser(UserModel model);
  
  /// Updates user password
  Future<bool> updatePassword({required String newPassword});
  
  /// Re-authenticates user with current password
  Future<bool> reAuthenticateUser({required String currentPassword});
  
  /// Uploads profile image to Cloud Storage and returns download URL
  Future<String?> uploadProfileImage({required File imageFile});
  
  /// Updates profile image URL in Firestore and Auth
  Future<bool> updateProfileImage({required String imageUrl});
}
