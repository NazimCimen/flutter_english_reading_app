import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:flutter/material.dart';

class CustomPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obsecureText;
  final VoidCallback changeObsecureText;
  const CustomPasswordTextField({
    required this.controller,
    required this.obsecureText,
    required this.changeObsecureText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => AppValidators.passwordValidator(value),
      obscureText: obsecureText,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
        labelText: StringConstants.passwordLabel,
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.grey, fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: context.cBorderRadiusAllMedium,
          borderSide: const BorderSide(color: AppColors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.cBorderRadiusAllMedium,
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.6), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.cBorderRadiusAllMedium,
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: context.cBorderRadiusAllMedium,
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: context.cBorderRadiusAllMedium,
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        suffixIcon: IconButton(
          onPressed: changeObsecureText,
          icon: Icon(
            obsecureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}
