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
  bool isGoogleLoading = false; // Google loading state
  AutovalidateMode isAutoValidateSignin = AutovalidateMode.disabled;
  bool obsecureText = true;
  late final AuthService _service;
  
  @override
  void initState() {
    mailController = TextEditingController();
    passwordController = TextEditingController();
    _service = AuthServiceImpl();
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
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
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
    return result;
  }

  /// GOOGLE İLE LOGİN
  Future<bool> signWithGoogle() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    // Set Google loading state
    setState(() {
      isGoogleLoading = true;
    });
    
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
      (isNewUser) {
        result = true;
        // Show success message for Google sign-in
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: 'Başarıyla giriş yaptınız!',
        );
      },
    );
    
    // Reset Google loading state
    setState(() {
      isGoogleLoading = false;
    });
    
    return result;
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
