import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/enum/image_enum.dart';
import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/splash/splash_mixin.dart';
import 'package:english_reading_app/product/constants/app_contants.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SplashMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primaryColor,
        child: Center(
          child: Padding(
            padding: context.cPaddingxxLarge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImageEnums.logo.toPathPng, fit: BoxFit.cover,width: context.cLargeValue*4, ),

                SizedBox(height: context.cMediumValue),
                Text(
                  AppContants.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
