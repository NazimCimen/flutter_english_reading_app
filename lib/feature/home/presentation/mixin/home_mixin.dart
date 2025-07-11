import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:english_reading_app/feature/home/presentation/view/home_view.dart';
import 'package:english_reading_app/feature/home/presentation/viewmodel/home_view_model.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

mixin HomeMixin on State<HomeView> {
  final PagingController<int, ArticleModel> _pagingController =
      PagingController(firstPageKey: 0);

  PagingController<int, ArticleModel> get pagingController => _pagingController;
  String _selectedCategory = 'all';
  String get selectedCategory => _selectedCategory;

  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchPage(0);
      _pagingController
        ..addPageRequestListener((pageKey) => _fetchPage(pageKey))
        ..addStatusListener((status) => _showError(status));

      if (mounted) {
        // Preload saved article IDs for better performance
        await context.read<HomeViewModel>().preloadSavedArticleIds();
      }
    });
  }

  /// Updates the selected category and refreshes the article list.
  /// Triggers a new data fetch with the selected category filter.
  void updateSelectedCategory(String newCategory) {
    if (_selectedCategory != newCategory) {
      setState(() {
        _selectedCategory = newCategory;
      });
      _pagingController.refresh();
    }
  }

  /// Toggles the save state of an article with user validation.
  /// Checks account status and email verification before allowing save/remove operations.
  Future<void> toggleArticleSave(ArticleModel article) async {
    // Check if user has account and email is verified
    final mainLayoutViewModel = context.read<MainLayoutViewModel>();
    if (!mainLayoutViewModel.hasAccount) {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: StringConstants.needAccountToSave,
      );
      return;
    }

    if (!mainLayoutViewModel.isMailVerified) {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: StringConstants.needEmailVerificationToSave,
      );
      return;
    }

    final homeViewModel = context.read<HomeViewModel>();
    final isCurrentlySaved = homeViewModel.isArticleSaved(article.articleId!);

    if (isCurrentlySaved) {
      // Remove article
      await homeViewModel.removeArticle(article.articleId!);
      if (mounted) {
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: StringConstants.articleRemovedFromSaved,
        );
      }
    } else {
      // Save article
      await homeViewModel.saveArticle(article);
      if (mounted) {
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: StringConstants.articleSavedSuccessfully,
        );
      }
    }
  }

  /// Checks if a specific article is saved by the current user.
  /// Delegates to the HomeViewModel for cached state checking.
  bool isArticleSaved(String articleId) {
    return context.read<HomeViewModel>().isArticleSaved(articleId);
  }

  /// Fetches a page of articles for infinite scroll pagination.
  /// Handles both initial load and subsequent page loads.
  Future<void> _fetchPage(int pageKey) async {
    final fetchedArticles = await context.read<HomeViewModel>().fetchArticles(
      categoryFilter: _selectedCategory,
      reset: pageKey == 0,
    );
    if (fetchedArticles.isEmpty) {
      _pagingController.appendLastPage([]);
    } else {
      _pagingController.appendPage(fetchedArticles, pageKey + 1);
    }
  }

  /// Shows error messages for pagination failures.
  /// Displays user-friendly error messages when page loading fails.
  void _showError(PagingStatus status) {
    if (status == PagingStatus.subsequentPageError) {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: StringConstants.somethingWentWrong,
      );
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
