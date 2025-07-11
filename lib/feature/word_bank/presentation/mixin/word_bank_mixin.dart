import 'package:english_reading_app/feature/word_bank/presentation/view/word_bank_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

mixin WordBankMixin on State<WordBankView> {
  late final PagingController<int, DictionaryEntry> _pagingController;
  PagingController<int, DictionaryEntry> get pagingController =>
      _pagingController;
  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 0);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // WordBankViewModel'e callback set et
      final viewModel = context.read<WordBankViewModel>();
      viewModel.onWordDeleted = refreshPagingController;
      
      await _fetchPage(0);
      _pagingController
        ..addPageRequestListener((pageKey) => _fetchPage(pageKey))
        ..addStatusListener((status) => _showError(status));
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    final viewModel = context.read<WordBankViewModel>();
    await viewModel.fetchWords(reset: pageKey == 0);
    if (viewModel.fetchedWords.isEmpty) {
      _pagingController.appendLastPage([]);
    } else {
      _pagingController.appendPage(viewModel.fetchedWords, pageKey + 1);
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

  void refreshPagingController() {
    _pagingController.refresh();
  }
}
