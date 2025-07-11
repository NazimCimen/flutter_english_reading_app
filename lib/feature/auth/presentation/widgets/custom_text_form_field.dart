import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  const CustomTextFormField({
    required this.controller,
    required this.validator,
    required this.labelText,
    required this.prefixIcon,
    required this.keyboardType,
    required this.textInputAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: AppColors.grey),
        labelText: labelText,
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.grey,),
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
      ),
    );
  }
}
