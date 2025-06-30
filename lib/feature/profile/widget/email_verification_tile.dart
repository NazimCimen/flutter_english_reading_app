import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:flutter/material.dart';

class EmailVerificationTile extends StatelessWidget {
  final MainLayoutViewModel mainLayoutViewModel;

  const EmailVerificationTile({
    super.key,
    required this.mainLayoutViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.paddingAllLow,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: context.borderRadiusAllMedium,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () async {
          final success = await mainLayoutViewModel.sendEmailVerification();
          if (success && context.mounted) {
            CustomSnackBars.showCustomBottomScaffoldSnackBar(
              context: context,
              text: 'Doğrulama e-postası gönderildi. Lütfen e-postanızı kontrol edin.',
            );
          } else if (context.mounted) {
            CustomSnackBars.showCustomBottomScaffoldSnackBar(
              context: context,
              text: 'Doğrulama e-postası gönderilemedi. Lütfen tekrar deneyin.',
            );
          }
        },
        leading: Container(
          padding: context.cPaddingSmall,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.email_outlined,
            color: AppColors.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          'E-posta Doğrula',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Hesabınızı tam olarak aktifleştirin',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        trailing: Container(
          padding: context.cPaddingSmall,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: context.borderRadiusAllLow,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
} 