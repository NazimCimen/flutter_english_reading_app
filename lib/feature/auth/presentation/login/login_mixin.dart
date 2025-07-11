import 'package:english_reading_app/core/error/handle_firebase_auth_error.dart';
import 'package:english_reading_app/feature/auth/presentation/login/login_view.dart';
import 'package:english_reading_app/feature/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:english_reading_app/di/di_container.dart';
import 'package:flutter/material.dart';

mixin LoginMixin on State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController mailController;
  late TextEditingController passwordController;
  bool isRequestAvailable = false;
  bool isGoogleLoading = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool obscureText = true;
  late final AuthViewModel _authViewModel;
  
  @override
  void initState() {
    mailController = TextEditingController();
    passwordController = TextEditingController();
    _authViewModel = getIt<AuthViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Attempts to log in user with email and password.
  /// Returns true if login is successful, false otherwise.
  Future<bool> loginUser() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    validateFields();
    var result = false;
    if (isRequestAvailable) {
      final response = await _authViewModel.login(
        email: mailController.text.trim(),
        password: passwordController.text.trim(),
      );
      response.fold(
        (failure) {
          makeRequestUnavailable();
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

  /// Signs in user with Google account.
  /// Returns true if sign-in is successful, false otherwise.
  Future<bool> signInWithGoogle() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    // Set Google loading state
    setState(() {
      isGoogleLoading = true;
    });
    
    var result = false;
    final response = await _authViewModel.signInWithGoogle();
    response.fold(
      (failure) {
        makeRequestUnavailable();
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
          text: StringConstants.successfullySignedIn,
        );
      },
    );
    
    // Reset Google loading state
    setState(() {
      isGoogleLoading = false;
    });
    
    return result;
  }

  /// Validates form fields and updates request availability status.
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

  /// Toggles password visibility in the password field.
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  /// Sets request availability to false and updates UI state.
  void makeRequestUnavailable() {
    setState(() {
      isRequestAvailable = false;
    });
  }
}
