import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:flutter/material.dart';

class EmailVerificationWidget extends StatelessWidget {
  final String title;
  final String description;
  final MainLayoutViewModel mainLayoutViewModel;

  const EmailVerificationWidget({
    required this.title,
    required this.description,
    required this.mainLayoutViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: context.paddingAllLarge,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.email_outlined,
              size: context.cXxLargeValue - 6,
              color: AppColors.primaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: context.cLargeValue),

          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.cLowValue),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),

          SizedBox(height: context.cXLargeValue),
          ElevatedButton.icon(
            onPressed: () async {
              if (!mainLayoutViewModel.hasAccount) {
                // Navigate to sign up page for users without account
                Navigator.of(context).pushNamed(AppRoutes.signupView);
                return;
              }
              
              final success = await mainLayoutViewModel.sendEmailVerification();
              if (success && context.mounted) {
                CustomSnackBars.showCustomBottomScaffoldSnackBar(
                  context: context,
                  text:
                      'Doğrulama e-postası gönderildi. Lütfen e-postanızı kontrol edin.',
                );
              } else if (context.mounted) {
                CustomSnackBars.showCustomBottomScaffoldSnackBar(
                  context: context,
                  text:
                      'Doğrulama e-postası gönderilemedi. Lütfen tekrar deneyin.',
                );
              }
            },
            icon: Icon(
              mainLayoutViewModel.hasAccount 
                ? Icons.email_outlined 
                : Icons.person_add_outlined, 
              color: AppColors.white
            ),
            label: Text(
              mainLayoutViewModel.hasAccount 
                ? 'Doğrulama E-postası Gönder'
                : 'Hesap Aç'
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: context.paddingHorizAllLarge + context.paddingVertAllMedium,
              shape: RoundedRectangleBorder(
                borderRadius: context.cBorderRadiusAllMedium
              ),
            ),
          ),
        ],
      ),
    );
  }
}
