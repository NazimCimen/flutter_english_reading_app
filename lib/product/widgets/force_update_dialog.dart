import 'dart:io';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateDialog extends StatelessWidget {
  final String message;
  final String? updateUrl;
  final bool isForceUpdate;

  const ForceUpdateDialog({
    super.key,
    required this.message,
    this.updateUrl,
    required this.isForceUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
              onWillPop: () async => !isForceUpdate, // Disable back button if force update
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: context.borderRadiusAllLarge,
        ),
        child: Padding(
          padding: context.paddingAllLarge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.system_update,
                size: context.dynamicWidht(0.15),
                color: AppColors.primaryColor,
              ),
              SizedBox(height: context.cMediumValue),
              Text(
                'Güncelleme Gerekli',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.cMediumValue),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.cLargeValue),
              Row(
                children: [
                  if (!isForceUpdate) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: context.paddingVertAllMedium,
                          shape: RoundedRectangleBorder(
                            borderRadius: context.borderRadiusAllMedium,
                          ),
                        ),
                        child: Text(
                          'Daha Sonra',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.cMediumValue),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openUpdateUrl(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: context.paddingVertAllMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: context.borderRadiusAllMedium,
                        ),
                      ),
                      child: Text(
                        'Güncelle',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUpdateUrl(BuildContext context) async {
    if (updateUrl != null && updateUrl!.isNotEmpty) {
      final Uri url = Uri.parse(updateUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Güncelleme linki açılamadı'),
            ),
          );
        }
      }
    } else {
      // Default store links based on platform
      String storeUrl;
      if (Platform.isAndroid) {
        storeUrl = 'https://play.google.com/store/apps/details?id=com.example.english_reading_app';
      } else if (Platform.isIOS) {
        storeUrl = 'https://apps.apple.com/app/id123456789'; // Add your App Store ID here
      } else {
        storeUrl = 'https://play.google.com/store/apps/details?id=com.example.english_reading_app';
      }

      final Uri url = Uri.parse(storeUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Store linki açılamadı'),
            ),
          );
        }
      }
    }
  }
} 