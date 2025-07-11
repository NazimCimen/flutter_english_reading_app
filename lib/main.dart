import 'package:easy_localization/easy_localization.dart';
import 'package:english_reading_app/config/theme/theme_manager.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/init/app_init.dart';
import 'package:provider/provider.dart';

void main() async {
  final appInit = AppInitImpl();
  await appInit.run();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) => MaterialApp(
            theme: themeManager.currentTheme,
            themeMode: themeManager.themeMode,
            title: StringConstants.appName,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorKey: NavigatorService.navigatorKey,
            routes: AppRoutes.routes,
            initialRoute: AppRoutes.initialRoute,
          ),
    );
  }
}
