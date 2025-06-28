import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';

class WordBankLoadingMoreIndicator extends StatelessWidget {
  const WordBankLoadingMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllMedium,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: context.cMediumValue,
              height: context.cMediumValue,
              child: CircularProgressIndicator(
                strokeWidth: context.cLowValue / 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(width: context.cLowValue),
            Text(
              'Daha fazla kelime yükleniyor...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 