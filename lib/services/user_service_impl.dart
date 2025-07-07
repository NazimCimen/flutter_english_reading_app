import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:english_reading_app/product/model/user_model.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class UserServiceImpl implements UserService {
  final BaseFirebaseService<UserModel> _userFirebaseService =
      FirebaseServiceImpl<UserModel>(firestore: FirebaseFirestore.instance);

  @override
  bool isUserSignIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Future<UserModel?> getUserById({required String? userId}) async {
    if (userId != null) {
      return _userFirebaseService.getItem(
        collectionPath: FirebaseCollectionEnum.users.name,
        docId: userId,
        model: const UserModel(),
      );
    } else {
      return null;
    }
  }

  @override
  Future<bool> setUserToFirestore() async {
    if (FirebaseAuth.instance.currentUser == null) return false;
    try {
      await _userFirebaseService.setItem(
        FirebaseCollectionEnum.users.name,
        UserModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          email: FirebaseAuth.instance.currentUser!.email,
          nameSurname: FirebaseAuth.instance.currentUser!.displayName,
          createdAt: DateTime.now().toUtc(),
          profileImageUrl: FirebaseAuth.instance.currentUser!.photoURL,
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateUser(UserModel model) async {
    if (FirebaseAuth.instance.currentUser == null) return false;
    try {
      await _userFirebaseService.setItem(
        FirebaseCollectionEnum.users.name,
        model,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updatePassword({required String newPassword}) async {
    if (FirebaseAuth.instance.currentUser == null) return false;
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> reAuthenticateUser({required String currentPassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      if (user.email == null) return false;
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> uploadProfileImage({required File imageFile}) async {
    if (FirebaseAuth.instance.currentUser == null) return null;
    
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(userId)
          .child('profile_images')
          .child(fileName);
      
      // Upload the image
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Profile image upload error: $e');
      return null;
    }
  }

  @override
  Future<bool> updateProfileImage({required String imageUrl}) async {
    if (FirebaseAuth.instance.currentUser == null) return false;
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      
      // Get current user information
      final currentUser = await getUserById(userId: userId);
      if (currentUser == null) return false;
      
      // Update profile image URL
      final updatedUser = currentUser.copyWith(profileImageUrl: imageUrl);
      
      // Update user document in Firestore
      await _userFirebaseService.updateItem(
        FirebaseCollectionEnum.users.name,
        userId,
        updatedUser,
      );
      
      // Update profile image in Firebase Auth as well
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
      
      return true;
    } catch (e) {
      print('Update profile image error: $e');
      return false;
    }
  }
} 