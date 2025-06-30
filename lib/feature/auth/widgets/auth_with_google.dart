import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/enum/image_enum.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AuthWithGoogle extends StatelessWidget {
  final String authWithGoogle;
  final VoidCallback onTap;
  const AuthWithGoogle({
    required this.onTap,
    required this.authWithGoogle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: AppColors.grey,
              ),
            ),
            Padding(
              padding: context.paddingHorizAllXlarge,
              child: Text(
                'Ya da',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: context.cMediumValue),
        GestureDetector(
          onTap: onTap,
          child: Container(
          padding: EdgeInsets.symmetric(vertical: context.cMediumValue *0.7),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.grey.withOpacity(0.5),
              ),
          borderRadius: context.cBorderRadiusAllMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  height: context.cMediumValue * 1.9,
                  ImageEnums.google_logo.toPathPng,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: context.cMediumValue),
                Text(
                  authWithGoogle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
