import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/config/theme/custom_color_sheme.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ApplicationTheme {
  ThemeData get themeData;
  ColorScheme get colorScheme;
}

/// Custom light theme for project design
final class CustomLightTheme implements ApplicationTheme {
  @override
  ColorScheme get colorScheme => CustomColorScheme.lightScheme;
  @override
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.roboto().fontFamily,
    colorScheme: CustomColorScheme.lightScheme,
    scaffoldBackgroundColor: AppColors.background,
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: Colors.grey.shade300,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withOpacity(0.2),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
  );
}

/// Custom Dark theme for project design
final class CustomDarkTheme implements ApplicationTheme {
  @override
  ColorScheme get colorScheme => CustomColorScheme.darkScheme;
  @override
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: CustomColorScheme.darkScheme,
    fontFamily: GoogleFonts.roboto().fontFamily,
    scaffoldBackgroundColor: const Color(0xFF121212),
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: Colors.grey.shade300,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withOpacity(0.2),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121212)),
  );
}
