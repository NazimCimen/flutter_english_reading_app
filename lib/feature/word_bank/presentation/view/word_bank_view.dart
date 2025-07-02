import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/presentation/view/word_detail_sheet.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_local_data_source.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_tile.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/app_bar.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_detail_sheet.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_loading_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_loading_more_indicator.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_empty_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_bank_error_view.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/widgets/email_verification_widget.dart';

class WordBankView extends StatefulWidget {
  const WordBankView({super.key});

  @override
  State<WordBankView> createState() => _WordBankViewState();
}

class _WordBankViewState extends State<WordBankView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = Provider.of<WordBankViewmodel>(context, listen: false);
    provider.searchWords(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordBankViewmodel>(context, listen: true);

    return Scaffold(
      appBar: WordBankAppBar(
        searchController: _searchController,
        isSearching: _isSearching,
        onSearchChanged: _onSearchChanged,
      ),

      body: Consumer<MainLayoutViewModel>(
        builder: (context, mainLayoutViewModel, child) {
          if (!mainLayoutViewModel.hasAccount) {
            return EmailVerificationWidget(
              title: 'Hesap Açmanız Gerekli',
              description:
                  'Kelime bankasına erişmek için lütfen hesap açın.',
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
          return _buildBody(context, provider);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, WordBankViewmodel provider) {
    if (provider.isLoading) {
      return const WordBankLoadingView();
    }

    return PagedListView<int, DictionaryEntry>(
      pagingController: provider.pagingController,
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
        noItemsFoundIndicatorBuilder: (context) => const WordBankEmptyView(),
        firstPageErrorIndicatorBuilder:
            (context) => WordBankErrorView(provider: provider),
        newPageErrorIndicatorBuilder:
            (context) => WordBankErrorView(provider: provider),
      ),
    );
  }
}
