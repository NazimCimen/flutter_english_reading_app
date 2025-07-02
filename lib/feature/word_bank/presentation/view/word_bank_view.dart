import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_tile.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/app_bar.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_shimmer_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_loading_more_indicator.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_empty_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_error_view.dart';
import 'package:english_reading_app/product/widgets/email_verification_widget.dart';

class WordBankView extends StatefulWidget {
  const WordBankView({super.key});

  @override
  State<WordBankView> createState() => _WordBankViewState();
}

class _WordBankViewState extends State<WordBankView> {
  final PagingController<int, DictionaryEntry> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchPage(0);
      _pagingController
        ..addPageRequestListener((pageKey) => _fetchPage(pageKey))
        ..addStatusListener((status) => _showError(status));
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    await context.read<WordBankViewmodel>().fetchWords(reset: pageKey == 0);
    if (context.read<WordBankViewmodel>().savedWords.isEmpty) {
      _pagingController.appendLastPage([]);
    } else {
      _pagingController.appendPage(
        context.read<WordBankViewmodel>().savedWords,
        pageKey + 1,
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      /*   appBar: WordBankAppBar(
        searchController: _searchController,
        isSearching: _isSearching,
        onSearchChanged: _onSearchChanged,
      ),*/
      body: Consumer<MainLayoutViewModel>(
        builder: (context, mainLayoutViewModel, child) {
          if (!mainLayoutViewModel.hasAccount) {
            return EmailVerificationWidget(
              title: 'Hesap Açmanız Gerekli',
              description: 'Kelime bankasına erişmek için lütfen hesap açın.',
              mainLayoutViewModel: mainLayoutViewModel,
            );
          }

          if (!mainLayoutViewModel.isMailVerified) {
            return EmailVerificationWidget(
              title: 'E-posta Doğrulaması Gerekli',
              description:
                  'Kelime bankasına erişmek için lütfen e-posta adresinizi doğrulayın.',
              mainLayoutViewModel: mainLayoutViewModel,
            );
          }
          return Consumer<WordBankViewmodel>(
            builder: (context, wordBankViewModel, child) {
              if (wordBankViewModel.isLoading) {
                return const WordBankLoadingView();
              }

              return Expanded(
                child: PagedListView<int, DictionaryEntry>(
                  pagingController: _pagingController,
                  padding:
                      context.paddingVertTopMedium +
                      context.paddingHorizAllLow +
                      context.paddingVertBottomXXlarge * 3,
                  builderDelegate: PagedChildBuilderDelegate<DictionaryEntry>(
                    itemBuilder: (context, word, index) => WordTile(word: word),
                    firstPageProgressIndicatorBuilder:
                        (context) => const WordBankLoadingView(),
                    newPageProgressIndicatorBuilder:
                        (context) => const WordBankLoadingMoreIndicator(),
                    noItemsFoundIndicatorBuilder:
                        (context) => const WordBankEmptyView(),
                    firstPageErrorIndicatorBuilder:
                        (context) => const WordBankErrorView(),
                    newPageErrorIndicatorBuilder:
                        (context) => const WordBankErrorView(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
