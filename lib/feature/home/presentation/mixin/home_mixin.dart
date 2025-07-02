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

  void updateSelectedCategory(String newCategory) {
    if (_selectedCategory != newCategory) {
      setState(() {
        _selectedCategory = newCategory;
      });
      _pagingController.refresh();
    }
  }

  Future<void> toggleArticleSave(ArticleModel article) async {
    try {
      // Check if user has account and email is verified
      final mainLayoutViewModel = context.read<MainLayoutViewModel>();
      if (!mainLayoutViewModel.hasAccount) {
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: 'Makale kaydetmek için hesap açmalısınız.',
        );
        return;
      }
      
      if (!mainLayoutViewModel.isMailVerified) {
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: 'Makale kaydetmek için e-posta adresinizi doğrulayın.',
        );
        return;
      }

      final homeViewModel = context.read<HomeViewModel>();
      final isCurrentlySaved = homeViewModel.isArticleSaved(article.articleId!);

      if (isCurrentlySaved) {
        // Remove article
        await homeViewModel.removeArticle(article.articleId!);
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: 'Makale kayıtlardan kaldırıldı.',
        );
      } else {
        // Save article
        await homeViewModel.saveArticle(article);
        CustomSnackBars.showCustomBottomScaffoldSnackBar(
          context: context,
          text: 'Makale başarıyla kaydedildi!',
        );
      }
    } catch (e) {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: 'İşlem başarısız. Lütfen tekrar deneyin.',
      );
    }
  }

  bool isArticleSaved(String articleId) {
    try {
      return context.read<HomeViewModel>().isArticleSaved(articleId);
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchPage(0);
      _pagingController
        ..addPageRequestListener((pageKey) => _fetchPage(pageKey))
        ..addStatusListener((status) => _showError(status));
      
      // Preload saved article IDs for better performance
      await context.read<HomeViewModel>().preloadSavedArticleIds();
    });
  }

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

  void _showError(PagingStatus status) {
    if (status == PagingStatus.subsequentPageError) {
      CustomSnackBars.showCustomBottomScaffoldSnackBar(
        context: context,
        text: 'Something went wrong. Try again later',
      );
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
