import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/feature/profile/viewmodel/profile_view_model.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/feature/home/presentation/viewmodel/home_view_model.dart';

/// Manager class to handle all viewmodel resets
class ViewModelManager {
  static final ViewModelManager _instance = ViewModelManager._internal();
  factory ViewModelManager() => _instance;
  ViewModelManager._internal();

  /// Reset all viewmodels when user logs out
  void resetAllViewModels(BuildContext context) {
    try {
      // Reset MainLayoutViewModel
      final mainLayoutViewModel = context.read<MainLayoutViewModel>();
      mainLayoutViewModel.resetAllViewModels();

      // Reset ProfileViewModel
      final profileViewModel = context.read<ProfileViewModel>();
      profileViewModel.reset();

      // Reset WordBankViewModel if available
      try {
        final wordBankViewModel = context.read<WordBankViewModel>();
     //   wordBankViewModel.reset();
      } catch (e) {
        // WordBankViewModel might not be available in all contexts
        debugPrint('WordBankViewModel not available for reset: $e');
      }

      // Reset SavedArticlesViewModel if available
      try {
        final savedArticlesViewModel = context.read<SavedArticlesViewModel>();
        savedArticlesViewModel.reset();
      } catch (e) {
        // SavedArticlesViewModel might not be available in all contexts
        debugPrint('SavedArticlesViewModel not available for reset: $e');
      }

      // Reset HomeViewModel if available
      try {
        final homeViewModel = context.read<HomeViewModel>();
        homeViewModel.clearCache();
      } catch (e) {
        // HomeViewModel might not be available in all contexts
        debugPrint('HomeViewModel not available for reset: $e');
      }

    } catch (e) {
      debugPrint('Error resetting viewmodels: $e');
    }
  }
} 