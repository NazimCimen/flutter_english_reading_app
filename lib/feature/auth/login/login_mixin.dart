import 'package:english_reading_app/core/cache/cache_enum.dart';
import 'package:english_reading_app/core/cache/cache_manager/base_cache_manager.dart';
import 'package:english_reading_app/core/cache/cache_manager/standart_cache_manager.dart';
import 'package:english_reading_app/core/error/handle_firebase_auth_error.dart';
import 'package:english_reading_app/feature/auth/login/login_view.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

mixin LoginMixin on State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController mailController;
  late TextEditingController passwordController;
  bool isRequestAvaible = false;
  AutovalidateMode isAutoValidateSignin = AutovalidateMode.disabled;
  bool obsecureText = true;
  bool rememberMe = false;
  late final AuthService _service;
  late final BaseCacheManager<String> _cacheManager;
  @override
  void initState() {
    mailController = TextEditingController();
    passwordController = TextEditingController();
    _service = AuthService();
    _cacheManager =
        StandartCacheManager(boxName: CacheHiveBoxEnum.authBox.name);
    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// LOGIN İŞLEMİ
  Future<bool> loginUser() async {
    validateFields();
    var result = false;
    if (isRequestAvaible) {
      final response = await _service.login(
        email: mailController.text.trim(),
        password: passwordController.text.trim(),
      );
      response.fold(
        (failure) {
          makeFalseIsRequestAvaliable();
          CustomSnackBars.showCustomBottomScaffoldSnackBar(
            context: context,
            text: HandleFirebaseAuthError.convertErrorMsg(
              errorCode: failure.errorMessage,
            ),
          );
          result = false;
        },
        (success) {
          result = true;
        },
      );
    }
    if (rememberMe && result) {
      await rememberMeButton();
    }
    return result;
  }

  /// GOOGLE İLE LOGİN
  Future<bool> signWithGoogle() async {
    var result = false;
    final response = await _service.signInWithGoogle();
    response.fold(
      (failure) {
        makeFalseIsRequestAvaliable();
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: HandleFirebaseAuthError.convertErrorMsg(
            errorCode: failure.errorMessage,
          ),
        );
        result = false;
      },
      (success) {
        result = success;
      },
    );
    if (rememberMe) {
      await rememberMeButton();
    }
    return result;
  }

  Future<void> rememberMeButton() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _cacheManager.saveData(
        data: user.uid,
        keyName: CacheKeyEnum.authRememberMe.name,
      );
    }
  }

  void checkBoxChanged(bool? value) {
    setState(() {
      rememberMe = value ?? false;
    });
  }

  ///it used to validate fields
  void validateFields() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isRequestAvaible = true;
      });
    } else {
      setState(() {});
    }
  }

  ///it used to control obsecure text for password field
  void changeObsecureText() {
    setState(() {
      obsecureText = !obsecureText;
    });
  }

  ///it used to control request avaliability
  void makeFalseIsRequestAvaliable() {
    setState(() {
      isRequestAvaible = false;
    });
  }
}
