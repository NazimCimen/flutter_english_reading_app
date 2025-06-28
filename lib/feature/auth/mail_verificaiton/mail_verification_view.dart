import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/enum/animation_enum.dart';
import 'package:english_reading_app/feature/auth/mail_verificaiton/mail_verification_mixin.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_auth_buttom.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MailVerificationView extends StatefulWidget {
  const MailVerificationView({super.key});

  @override
  State<MailVerificationView> createState() => _MailVerificationViewState();
}

class _MailVerificationViewState extends State<MailVerificationView>
    with MailVerificationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: context.paddingAllMedium,
          child: Visibility(
            replacement: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: context.dynamicWidht(0.2),
                  color: AppColors.green,
                ),
                SizedBox(height: context.cMediumValue),
                Text(
                  StringConstants.mailVerified,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            visible: !isEmailVerified,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringConstants.verifyEmail,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.cMediumValue),
                SizedBox(
                  width: context.dynamicWidht(0.5),
                  height: context.dynamicWidht(0.5),
                  child: Lottie.asset(
                    AnimationEnum.verification.toPathJson,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: context.cMediumValue),
                if (isCheckingEmail) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.cMediumValue,
                        height: context.cMediumValue,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: context.cLowValue),
                      Text(
                        'E-posta kontrol ediliyor...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.cMediumValue),
                ],
                SizedBox(
                  width: double.infinity,
                  child: CustomAuthButtonWidget(
                    onPressed: resendEmailVerification,
                    text: StringConstants.resendMailVerification,
                    isRequestAvaliable: isResendRequestAvailable,
                  ),
                ),
                SizedBox(height: context.cMediumValue),
                Text(
                  'E-posta doğrulandığında otomatik olarak ana sayfaya yönlendirileceksiniz.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
