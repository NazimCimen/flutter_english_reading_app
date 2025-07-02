import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
import 'package:english_reading_app/feature/auth/sign_up/sign_up_mixin.dart';
import 'package:english_reading_app/feature/auth/widgets/auth_with_google.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_auth_buttom.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_password_text_field.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_text_form_field.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/constants/string_constants.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_reading_app/feature/auth/widgets/custom_app_bar.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with SignupMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'L I N G Z Y !'),

      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: context.paddingHorizAllMedium,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.cMediumValue),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    StringConstants.signUpTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(height: 1.5),
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,

                  StringConstants.signUpSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: context.cMediumValue),

                CustomTextFormField(
                  controller: nameController,
                  validator: (value) => AppValidators.nameValidator(value),
                  labelText: StringConstants.nameLabel,
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: context.cLowValue),
                CustomTextFormField(
                  controller: emailController,
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
                Row(
                  children: [
                    Checkbox(
                      value: isTermsAgreed,
                      onChanged: (value) {
                        checkBoxChanged(value);
                      },
                    ),
                    Text(
                      StringConstants.termsAgreement,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        StringConstants.termsAcceptance,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.cLowValue),
                CustomAuthButtonWidget(
                  onPressed: () async {
                    final result = await signupUser();
                    if (result) {
                      final result = await UserService().setUserToFirestore();
                      if (result) {
                        await NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.mainLayoutView,
                        );
                      } else {
                        await FirebaseAuth.instance.currentUser!.delete();
                      }
                    }
                  },
                  text: StringConstants.signUpButton,
                  isRequestAvaliable: isRequestAvaible,
                ),
                SizedBox(height: context.cMediumValue),
                AuthWithGoogle(
                  authWithGoogle: 'Google İle Kayıt Ol',
                  isLoading: isGoogleLoading,
                  onTap: () async {
                    await signWithGoogle();
                    await NavigatorService.pushNamedAndRemoveUntil(
                      AppRoutes.mainLayoutView,
                    );
                  },
                ),
                SizedBox(height: context.cMediumValue),
                TextButton(
                  onPressed: () async {
                    // Continue without account - go directly to main layout
                    await NavigatorService.pushNamedAndRemoveUntil(
                      AppRoutes.mainLayoutView,
                    );
                  },
                  child: Text(
                    'Hesap açmadan devam et',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: context.cXLargeValue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringConstants.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    InkWell(
                      child: Text(
                        StringConstants.login,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.loginView,
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: context.cXLargeValue * 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
