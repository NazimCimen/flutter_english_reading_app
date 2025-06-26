import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Deneme extends StatelessWidget {
  const Deneme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Verb',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),
          Text(
            'go',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),

          SizedBox(height: context.cMediumValue),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.volumeHigh, color: AppColors.white),
            ],
          ),
        ],
      ),
    );
  }
}
