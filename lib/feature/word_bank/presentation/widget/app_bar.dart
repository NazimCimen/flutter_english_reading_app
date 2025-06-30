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
    return context.watch<MainLayoutViewModel>().isMailVerified == true
        ? AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          title:
              isSearching
                  ? TextField(
                    controller: searchController,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                    decoration: InputDecoration(
                      hintText: 'Kelime ara...',
                      hintStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: AppColors.black.withOpacity(0.7)),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: AppColors.black),
                    ),
                    onChanged: (value) => onSearchChanged(),
                  )
                  : Text(
                    'Kelime Bankası',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          actions: [
            if (isSearching)
              IconButton(
                icon: Icon(Icons.clear, color: AppColors.black),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged();
                },
              )
            else
              IconButton(
                icon: Icon(Icons.search, color: AppColors.black),
                onPressed: () {
                  // Search mode'u aktif et
                },
              ),
            IconButton(
              icon: Icon(Icons.add, color: AppColors.black),
              onPressed:
                  () => NavigatorService.pushNamed(AppRoutes.addWordView),
            ),
          ],
        )
        : const SizedBox.shrink();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
