import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextSpanBuilder {
  final String fullText;
  final int? highlightStart;
  final int? highlightEnd;
  final double fontSize;
  final BuildContext context;
  final Future<void> Function(String word) onWordTap;

  TextSpanBuilder({
    required this.fullText,
    required this.context,
    required this.fontSize,
    required this.onWordTap,
    this.highlightStart,
    this.highlightEnd,
  });

  List<TextSpan> build() {
    final spans = <TextSpan>[];

    final beforeHighlight =
        highlightStart != null
            ? fullText.substring(0, highlightStart!)
            : fullText;
    final highlightText =
        (highlightStart != null && highlightEnd != null)
            ? fullText.substring(highlightStart!, highlightEnd!)
            : '';
    final afterHighlight =
        (highlightEnd != null) ? fullText.substring(highlightEnd!) : '';

    // Önceki metni kelimelere böl
    spans.addAll(_buildTappableSpans(beforeHighlight));

    // Vurgulu kelime
    if (highlightText.isNotEmpty) {
      spans.add(_buildHighlightSpan(highlightText));
    }

    // Sonraki metni kelimelere böl
    spans.addAll(_buildTappableSpans(afterHighlight));

    return spans;
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
                await onWordTap(word);
              },
      );
    }).toList();
  }

  TextSpan _buildHighlightSpan(String word) {
    return TextSpan(
      text: word,
      style: TextStyle(
        backgroundColor: AppColors.primaryColorSoft,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        fontFamily: GoogleFonts.merriweather().fontFamily,
      ),
      recognizer:
          TapGestureRecognizer()
            ..onTap = () async {
              await onWordTap(word);
            },
    );
  }
}
