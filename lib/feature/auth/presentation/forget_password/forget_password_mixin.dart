import 'package:english_reading_app/feature/auth/presentation/forget_password/forget_password_view.dart';
import 'package:english_reading_app/feature/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/core/error/handle_firebase_auth_error.dart';
import 'package:english_reading_app/di/di_container.dart';
import 'package:flutter/material.dart';

mixin ForgetPasswordMixin on State<ForgetPasswordView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController mailController;
  bool isRequestAvailable = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late final AuthViewModel _authViewModel;
  bool isResetMailSent = false;

  @override
  void initState() {
    mailController = TextEditingController();
    _authViewModel = getIt<AuthViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    super.dispose();
  }

  /// Validates the form fields and updates request availability status.
  void validateFields() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isRequestAvailable = true;
      });
    } else {
      setState(() {
        autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  /// Sets request availability to false and updates UI state.
  void makeRequestUnavailable() {
    setState(() {
      isRequestAvailable = false;
    });
  }

  /// Updates the reset mail sent status and refreshes UI.
  void setResetMailSentStatus(bool value) {
    setState(() {
      isResetMailSent = value;
    });
  }

  /// Sends password reset email to the provided email address.
  /// Shows appropriate success or error messages to user.
  Future<void> sendPasswordResetEmail() async {
    validateFields();
    if (isRequestAvailable) {
      final result = await _authViewModel.sendPasswordResetEmail(
        email: mailController.text.trim(),
      );
      result.fold(
        (failure) {
          makeRequestUnavailable();
          CustomSnackBars.showCustomBottomScaffoldSnackBar(
            context: context,
            text: HandleFirebaseAuthError.convertErrorMsg(
              errorCode: failure.errorMessage,
            ),
          );
        },
        (success) {
          setResetMailSentStatus(true);
          makeRequestUnavailable();
        },
      );
    }
  }
}
