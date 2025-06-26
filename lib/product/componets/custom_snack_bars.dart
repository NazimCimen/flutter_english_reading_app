import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

@immutable
class CustomSnackBars {
  const CustomSnackBars._();
  static void showCustomBottomScaffoldSnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        content: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.background),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showCustomTopScaffoldSnackBar({
    required BuildContext context,
    required String text,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        icon: const Icon(Icons.error_outline, size: 60, color: AppColors.white),
        backgroundColor: AppColors.primaryColor,
        message: text,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        content: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.background),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
