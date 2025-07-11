import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';

@immutable
final class CustomDialogs {
  const CustomDialogs._();
  static void showWordDeleteConfirmation(
    BuildContext context,
    WordBankViewModel provider,
    String word,
  ) {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Kelimeyi Sil',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              '"${'word'}" kelimesini silmek istediğinizden emin misiniz?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'İptal',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  // provider.deleteWord(word.documentId!);
                  Navigator.pop(context);
                },
                child: Text(
                  'Sil',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.red),
                ),
              ),
            ],
          ),
    );
  }

  static void showProfileImageLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: context.dynamicWidht(0.6),
            maxHeight: context.dynamicHeight(0.3),
          ),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.cMediumValue),
            ),
            child: Padding(
              padding: context.paddingAllMedium,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomProgressIndicator(),
                  SizedBox(height: context.cMediumValue),
                  Text(
                    'Yükleniyor...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
