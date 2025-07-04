import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';

@immutable
final class CustomDialogs {
  const CustomDialogs._();
  static void showWordDeleteConfirmation(
    BuildContext context,
    WordBankViewModel provider,
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
}
