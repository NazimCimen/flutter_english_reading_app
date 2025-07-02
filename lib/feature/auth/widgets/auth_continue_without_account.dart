import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:flutter/material.dart';

class AuthContinueWithoutAccount extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  const AuthContinueWithoutAccount({
    required this.onTap,
    this.label = 'Hesap açmadan devam et',
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.cMediumValue * 0.7),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
          borderRadius: context.cBorderRadiusAllMedium,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: context.cMediumValue * 1.9,
                height: context.cMediumValue * 1.9,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            else
              Icon(
                Icons.login,
                color: Theme.of(context).colorScheme.onSurface,
                size: context.cMediumValue * 1.9,
              ),
            SizedBox(width: context.cMediumValue),
            if (isLoading)
              Text(
                'Devam ediliyor...',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              )
            else
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
} 