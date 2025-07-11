import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
import 'package:english_reading_app/feature/auth/presentation/sign_up/sign_up_mixin.dart';
import 'package:english_reading_app/feature/auth/presentation/widgets/auth_with_google.dart';
import 'package:english_reading_app/feature/auth/presentation/widgets/custom_auth_buttom.dart';
import 'package:english_reading_app/feature/auth/presentation/widgets/custom_password_text_field.dart';
import 'package:english_reading_app/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/feature/auth/presentation/widgets/auth_continue_without_account.dart';
import 'package:english_reading_app/product/services/url_service.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with SignupMixin {
  final urlService = UrlServiceImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: context.paddingHorizAllMedium,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: context.cXLargeValue),
                        Center(
                          child: Icon(
                            Icons.person_add_alt_1_outlined,
                            size: context.cLargeValue * 2,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: context.cLowValue),
                        Text(
                          textAlign: TextAlign.center,
                          StringConstants.signUpTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(height: 1.5),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          StringConstants.signUpSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.grey, height: 1.5),
                        ),
                        SizedBox(height: context.cXLargeValue),
                        CustomTextFormField(
                          controller: nameController,
                          validator:
                              (value) => AppValidators.nameValidator(value),
                          labelText: StringConstants.nameLabel,
                          prefixIcon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: context.cLowValue),
                        CustomTextFormField(
                          controller: emailController,
                          validator:
                              (value) => AppValidators.emailValidator(value),
                          labelText: StringConstants.emailLabel,
                          prefixIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: context.cLowValue),
                        CustomPasswordTextField(
                          controller: passwordController,
                          obsecureText: obscureText,
                          changeObsecureText: togglePasswordVisibility,
                        ),
                        SizedBox(height: context.cLowValue),
                        Row(
                          children: [
                            Checkbox(
                              value: isTermsAgreed,
                              onChanged: (value) {
                                onTermsCheckboxChanged(value);
                              },
                            ),
                            InkWell(
                              onTap: () async {
                                await urlService.launchTermsConditions();
                              },
                              child: Text(
                                StringConstants.termsAgreement,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                StringConstants.termsAcceptance,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.cLowValue),
                        CustomAuthButtonWidget(
                          onPressed: () async {
                            final result = await signupUser();
                            if (result) {
                              final firestoreResult =
                                  await saveUserToFirestore();
                              if (firestoreResult) {
                                await NavigatorService.pushNamedAndRemoveUntil(
                                  AppRoutes.mainLayoutView,
                                );
                              } else {
                                // User creation succeeded but Firestore save failed
                                // Show error message but don't delete user
                                if (context.mounted) {
                                  CustomSnackBars.showCustomBottomScaffoldSnackBar(
                                    context: context,
                                    text: StringConstants.accountCreatedButProfileFailed,
                                  );
                                }
                              }
                            }
                          },
                          text: StringConstants.signUpButton,
                          isRequestAvaliable: isRequestAvailable,
                        ),
                        SizedBox(height: context.cMediumValue),
                        AuthWithGoogle(
                          authWithGoogle: StringConstants.signUpWithGoogle,
                          isLoading: isGoogleLoading,
                          onTap: () async {
                            final result = await signInWithGoogle();
                            if (result) {
                              await NavigatorService.pushNamedAndRemoveUntil(
                                AppRoutes.mainLayoutView,
                              );
                            }
                          },
                        ),
                        SizedBox(height: context.cMediumValue),
                        AuthContinueWithoutAccount(
                          onTap: () async {
                            await NavigatorService.pushNamedAndRemoveUntil(
                              AppRoutes.mainLayoutView,
                            );
                          },
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
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
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
                        SizedBox(height: context.cXLargeValue*2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
