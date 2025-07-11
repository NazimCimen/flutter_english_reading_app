import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextSpanBuilder {
  final String fullText;
  final double fontSize;
  final BuildContext context;
  final Future<void> Function(String word) onWordTap;

  TextSpanBuilder({
    required this.fullText,
    required this.context,
    required this.fontSize,
    required this.onWordTap,
  });

  List<TextSpan> build() {
    return _buildTappableSpans(fullText);
  }

  List<TextSpan> _buildTappableSpans(String text) {
    final words = text.split(' ');
    return words.map((word) {
      if (word.trim().isEmpty) return const TextSpan(text: ' ');
      return TextSpan(
        text: '$word ',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: fontSize,
          height: 2.5,
          fontFamily: GoogleFonts.merriweather().fontFamily,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        recognizer:
            TapGestureRecognizer()
              ..onTap = () async {
                final pureWord = word.replaceAll(
                  RegExp(r'^[^\w]+|[^\w]+$'),
                  '',
                );
                await onWordTap(pureWord);
              },
      );
    }).toList();
  }
}
