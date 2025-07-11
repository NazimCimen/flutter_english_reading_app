import 'package:animate_do/animate_do.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
import 'package:english_reading_app/core/utils/enum/image_enum.dart';
import 'package:english_reading_app/feature/auth/presentation/forget_password/forget_password_mixin.dart';
import 'package:english_reading_app/feature/auth/presentation/widgets/custom_auth_buttom.dart';
import 'package:english_reading_app/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView>
    with ForgetPasswordMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: context.paddingHorizAllMedium,
          child: SingleChildScrollView(
            child: Visibility(
              visible: !isResetMailSent,
              replacement: FadeInRight(child: _mailSended(context)),
              child: FadeInLeft(child: _sendMail(context)),
            ),
          ),
        ),
      ),
    );
  }

  Column _mailSended(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: context.cXxLargeValue),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: context.cLargeValue,
          ),
          child: Image.asset(
            ImageEnums.refresh_password.toPathPng,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: context.cXLargeValue),
        Text(
          StringConstants.afterRefreshMail,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.grey,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
        SizedBox(height: context.cMediumValue),
        CustomAuthButtonWidget(
          onPressed: () {
            NavigatorService.pushNamed(AppRoutes.loginView);
          },
          text: StringConstants.login,
          isRequestAvaliable: false,
        ),
        SizedBox(height: context.cMediumValue),
      ],
    );
  }

  Form _sendMail(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: context.cXxLargeValue),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: context.cLargeValue,
            ),
            child: Image.asset(
              ImageEnums.forget_password.toPathPng,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: context.cXLargeValue),
          Text(
            StringConstants.refreshPassword,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          Text(
            StringConstants.enterMailForRefresh,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.grey,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          SizedBox(height: context.cMediumValue),
          CustomTextFormField(
            controller: mailController,
            validator: (value) => AppValidators.emailValidator(value),
            labelText: StringConstants.emailLabel,
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: context.cLowValue),
          CustomAuthButtonWidget(
            onPressed: () async {
              await sendPasswordResetEmail();
            },
            text: StringConstants.send,
            isRequestAvaliable: isRequestAvailable,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              NavigatorService.pushNamed(AppRoutes.loginView);
            },
            child: Text(
              StringConstants.login,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
