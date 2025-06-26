import 'dart:async';
import 'package:english_reading_app/core/error/handle_firebase_auth_error.dart';
import 'package:english_reading_app/feature/auth/sign_up/sign_up_view.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin SignupMixin on State<SignUpView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final FirebaseAuth auth;
  bool isRequestAvaible = false;
  AutovalidateMode isAutoValidateSignin = AutovalidateMode.disabled;
  bool obsecureText = true;
  bool? isEmailVerified = false;
  bool isVerificationMailSent = false;
  Timer? timer;
  bool isTermsAgreed = false;
  late final AuthService _service;
  @override
  void initState() {
    _service = AuthService();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    timer?.cancel();
    super.dispose();
  }

  /// KAYIT OLMA İŞLEMİ
  /// Yanıt void dönerse kayıt işlemi başarılı.
  /// Failure dönerse başarısız
  Future<bool> signupUser() async {
    valiadateFields();
    var result = false;
    if (isRequestAvaible && isTermsAgreed) {
      final signupResult = await _service.signup(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
      );
      signupResult.fold(
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
        (succes) {
          result = true;
        },
      );
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
    return result;
  }

  void checkBoxChanged(bool? value) {
    setState(() {
      isTermsAgreed = value ?? false;
    });
  }

  ///it used to validate the form fields
  void valiadateFields() {
    if (formKey.currentState!.validate() && isTermsAgreed) {
      setState(() {
        isRequestAvaible = true;
      });
    } else if (isTermsAgreed == false) {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: 'Lütfen kullanım koşullarını kabul ediniz.',
      );
      setState(() {
        isRequestAvaible = false;
      });
    } else {
      setState(() {
        isAutoValidateSignin = AutovalidateMode.always;
      });
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
