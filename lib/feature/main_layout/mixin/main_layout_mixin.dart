import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin MainLayoutMixin on State<MainLayoutView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MainLayoutViewModel>().loadUser();
    });
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    super.initState();
  }
}
