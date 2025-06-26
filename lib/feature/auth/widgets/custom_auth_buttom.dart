import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAuthButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isRequestAvaliable;
  const CustomAuthButtonWidget({
    required this.onPressed,
    required this.text,
    required this.isRequestAvaliable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: context.cMediumValue * 0.8),
          shape: RoundedRectangleBorder(
          borderRadius: context.cBorderRadiusAllMedium,
          ),
        ),
        onPressed: onPressed,
        child:
            isRequestAvaliable
                ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.surface,
                )
                : Text(
                  text,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.background),
                ),
      ),
    );
  }
}
