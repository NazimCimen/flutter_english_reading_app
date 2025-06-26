import 'package:english_reading_app/feature/auth/forget_password/forget_password_view.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

mixin ForgetPasswordMixin on State<ForgetPasswordView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController mailController;
  bool isRequestAvaible = false;
  AutovalidateMode isAutoValidateSignin = AutovalidateMode.disabled;
  late final FirebaseAuth auth;
  // final IErrorMapper errorMapper = ErrorMapper();
  bool isRefreshMailSended = false;
  @override
  void initState() {
    mailController = TextEditingController();
    auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    super.dispose();
  }

  ///it used to validate the form fields
  void validateFields() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isRequestAvaible = true;
      });
    } else {
      setState(() {
        /// burası gereksiz. tekrar kontrol et sonra kaldır.
        //    isAutoValidateSignin = AutovalidateMode.always;
      });
    }
  }

  ///it used to control request avaliability
  void makeFalseIsRequestAvaliable() {
    setState(() {
      isRequestAvaible = false;
    });
  }

  void setIsRefreshMailSended(bool value) {
    setState(() {
      isRefreshMailSended = true;
    });
  }

  Future<void> refreshPassword() async {
    validateFields();
    if (isRequestAvaible) {
      try {
        await auth.sendPasswordResetEmail(email: mailController.text.trim());
        setIsRefreshMailSended(true);
        makeFalseIsRequestAvaliable();
      } on FirebaseAuthException catch (e) {
        makeFalseIsRequestAvaliable();
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: e.code,
        );
      }
    }
  }
}
