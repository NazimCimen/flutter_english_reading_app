import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/presentation/mixin/word_bank_mixin.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/show_search_delegate.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_tile.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_shimmer_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_loading_more_indicator.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_empty_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_error_view.dart';
import 'package:english_reading_app/product/widgets/email_verification_widget.dart';
part '../widget/app_bar.dart';

class WordBankView extends StatefulWidget {
  const WordBankView({super.key});

  @override
  State<WordBankView> createState() => _WordBankViewState();
}

class _WordBankViewState extends State<WordBankView> with WordBankMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _WordBankAppBar(),
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
          return PagedListView<int, DictionaryEntry>(
            pagingController: pagingController,
            padding:
                context.paddingVertTopMedium +
                context.paddingHorizAllLow +
                context.paddingVertBottomXXlarge * 3,
            builderDelegate: PagedChildBuilderDelegate<DictionaryEntry>(
              itemBuilder: (context, word, index) => WordTile(word: word),
              firstPageProgressIndicatorBuilder:
                  (context) => SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const WordBankLoadingView(),
                  ),
              newPageProgressIndicatorBuilder:
                  (context) => const WordBankLoadingMoreIndicator(),
              noItemsFoundIndicatorBuilder:
                  (context) => const WordBankEmptyView(),
              firstPageErrorIndicatorBuilder:
                  (context) => const WordBankErrorView(),
              newPageErrorIndicatorBuilder:
                  (context) => const WordBankErrorView(),
            ),
          );
        },
      ),
    );
  }
}
