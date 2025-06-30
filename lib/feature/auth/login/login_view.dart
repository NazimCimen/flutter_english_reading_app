import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
import 'package:english_reading_app/core/utils/enum/image_enum.dart';
import 'package:english_reading_app/feature/auth/login/login_mixin.dart';
import 'package:english_reading_app/feature/auth/widgets/auth_with_google.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_app_bar.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_auth_buttom.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_password_text_field.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_text_form_field.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with LoginMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'L I N G Z Y !'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: context.paddingHorizAllMedium,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.cMediumValue),
                  Center(
                    child: Text(
                      StringConstants.loginTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(height: 1.5),
                    ),
                  ),
                  Center(
                    child: Text(
                      StringConstants.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: context.cMediumValue),
                  CustomTextFormField(
                    controller: mailController,
                    validator: (value) => AppValidators.emailValidator(value),
                    labelText: StringConstants.emailLabel,
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: context.cLowValue),
                  CustomPasswordTextField(
                    controller: passwordController,
                    obsecureText: obsecureText,
                    changeObsecureText: changeObsecureText,
                  ),
                  SizedBox(height: context.cLowValue),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.forgetPasswordView,
                        );
                      },
                      child: Text(
                        StringConstants.forgotPassword,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.cLowValue),
                  CustomAuthButtonWidget(
                    onPressed: () async {
                      final result = await loginUser();
                      if (result) {
                        await NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.navBarView,
                        );
                      }
                    },
                    text: StringConstants.loginButton,
                    isRequestAvaliable: isRequestAvaible,
                  ),
                  SizedBox(height: context.cMediumValue),
                  AuthWithGoogle(
                    authWithGoogle: StringConstants.loginWithGoogle,
                    onTap: () async {
                      final result = await signWithGoogle();
                      if (result) {
                        await NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.mailVerification,
                        );
                      } else {
                        await NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.navBarView,
                        );
                      }
                    },
                  ),
                  SizedBox(height: context.cXLargeValue),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.noAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      InkWell(
                        child: Text(
                          StringConstants.signUp,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          NavigatorService.pushNamedAndRemoveUntil(
                            AppRoutes.signupView,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
