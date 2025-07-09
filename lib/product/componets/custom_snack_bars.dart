import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

@immutable
class CustomSnackBars {
  const CustomSnackBars._();
  
  static void showErrorSnackBar(String message) {
    // Global error snackbar - context gerektirmeyen
    // Bu method ViewModel'de kullanılabilir
    print('Error: $message'); // Şimdilik sadece print, daha sonra global snackbar eklenebilir
  }

  static void showSuccessSnackBar(String message) {
    // Global success snackbar - context gerektirmeyen
    // Bu method ViewModel'de kullanılabilir
    print('Success: $message'); // Şimdilik sadece print, daha sonra global snackbar eklenebilir
  }

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
    required IconData icon,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        icon:  Icon(icon, size: 60, color: AppColors.white.withOpacity(0.2)),
        backgroundColor: AppColors.primaryColor,
        message: text,
      ),
    );

  }
}
