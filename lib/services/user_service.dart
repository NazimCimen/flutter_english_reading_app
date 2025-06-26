import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:english_reading_app/product/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// internet kontrolu yapılacak önemli
class UserService {
  final BaseFirebaseService<UserModel> _userFirebaseService =
      FirebaseServiceImpl<UserModel>(firestore: FirebaseFirestore.instance);

  /// Sistemde mevcut kullanıcı giriş yapmış olarak gözüküyor ise true değilse false döner.
  bool isUserSignIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  /// Sistemde mevcut kullanıcı giriş yapmış olarak gözüküyor ise user'in id'sini döner.değilse null döner
  String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  /// Id'ye göre user documentini return eder.
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

  Future<bool> updatePassword({required String newPassword}) async {
    if (FirebaseAuth.instance.currentUser == null) return false;
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

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

  Future<bool> updateProfileImage({required String imageUrl}) async {
    if (FirebaseAuth.instance.currentUser == null) return false;
    try {
      //   await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }
}
