import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';

class WordBankEmptyView extends StatelessWidget {
  const WordBankEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: context.paddingAllLarge,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_outline,
              size: context.cXxLargeValue - 6,
              color: AppColors.primaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: context.cLargeValue),
          Text(
            'Henüz kelime kaydetmediniz',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.cLowValue),
          Text(
            'Makalelerde kelimelerin üzerine tıklayarak\nkelime bankasına ekleyebilirsiniz',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          SizedBox(height: context.cXLargeValue),
          ElevatedButton.icon(
            onPressed: () => NavigatorService.pushNamed(AppRoutes.addWordView),
            icon: const Icon(Icons.add, color: AppColors.white),
            label: const Text('Kelime Ekle'), 
          
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: context.paddingHorizAllLarge + context.paddingVertAllMedium,
              shape: RoundedRectangleBorder(
                borderRadius: context.borderRadiusAllMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 