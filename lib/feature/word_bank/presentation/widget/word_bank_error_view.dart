import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';

class WordBankErrorView extends StatelessWidget {
  final WordBankViewmodel provider;
  
  const WordBankErrorView({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllLarge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: context.cXxLargeValue - 6,
            color: AppColors.red,
          ),
          SizedBox(height: context.cMediumValue),
          Text(
            'Bir hata oluştu',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.red,
            ),
          ),
          SizedBox(height: context.cLowValue),
          ElevatedButton(
            onPressed: () => provider.refreshWords(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: context.paddingHorizAllMedium + context.paddingVertAllLow,
              shape: RoundedRectangleBorder(
                borderRadius: context.borderRadiusAllMedium,
              ),
            ),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
} 