import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/feature/main_layout/export.dart';

class WordBankAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onSearchChanged;

  const WordBankAppBar({
    super.key,
    required this.searchController,
    required this.isSearching,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.white,
      elevation: 0,
      title: isSearching
          ? TextField(
              controller: searchController,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Kelime ara...',
                hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white.withOpacity(0.7),
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.white.withOpacity(0.7),
                ),
              ),
              onChanged: (value) => onSearchChanged(),
            )
          : Text(
              'Kelime Bankası',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [
        if (isSearching)
          IconButton(
            icon: Icon(Icons.clear, color: AppColors.white),
            onPressed: () {
              searchController.clear();
              onSearchChanged();
            },
          )
        else
          IconButton(
            icon: Icon(Icons.search, color: AppColors.white),
            onPressed: () {
              // Search mode'u aktif et
            },
          ),
        IconButton(
          icon: Icon(Icons.add, color: AppColors.white),
          onPressed: () => NavigatorService.pushNamed(AppRoutes.addWordView),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 