import 'dart:async';
import 'package:english_reading_app/core/error/handle_firebase_auth_error.dart';
import 'package:english_reading_app/feature/auth/presentation/sign_up/sign_up_view.dart';
import 'package:english_reading_app/feature/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:english_reading_app/di/di_container.dart';
import 'package:flutter/material.dart';

mixin SignupMixin on State<SignUpView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool isRequestAvailable = false;
  bool isGoogleLoading = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool obscureText = true;
  bool isTermsAgreed = false;
  late final AuthViewModel _authViewModel;

  @override
  void initState() {
    _authViewModel = getIt<AuthViewModel>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  /// Creates a new user account with provided credentials.
  /// Returns true if signup is successful, false otherwise.
  Future<bool> signupUser() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    validateFields();
    var result = false;
    if (isRequestAvailable && isTermsAgreed) {
      final signupResult = await _authViewModel.signup(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
      );
      signupResult.fold(
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

  /// Handles terms and conditions checkbox state changes.
  void onTermsCheckboxChanged(bool? value) {
    setState(() {
      isTermsAgreed = value ?? false;
    });
  }

  /// Validates form fields and terms agreement.
  /// Updates request availability and shows appropriate messages.
  void validateFields() {
    if (formKey.currentState!.validate() && isTermsAgreed) {
      setState(() {
        isRequestAvailable = true;
      });
    } else if (!isTermsAgreed) {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: StringConstants.pleaseAcceptTerms,
      );
      setState(() {
        isRequestAvailable = false;
      });
    } else {
      setState(() {
        autoValidateMode = AutovalidateMode.always;
        isRequestAvailable = false;
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

  /// Saves current user to Firestore after successful signup.
  /// Returns true if successful, false otherwise.
  Future<bool> saveUserToFirestore() async {
    final result = await _authViewModel.saveUserToFirestore();
    return result.fold(
      (failure) {
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: HandleFirebaseAuthError.convertErrorMsg(
            errorCode: failure.errorMessage,
          ),
        );
        return false;
      },
      (success) => success,
    );
  }
}
