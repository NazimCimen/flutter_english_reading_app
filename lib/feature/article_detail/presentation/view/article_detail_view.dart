import 'dart:ui';

import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/feature/article_detail/presentation/view/span_builder.dart';
import 'package:english_reading_app/product/componets/custom_sheets.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/enum/image_enum.dart';
import 'package:english_reading_app/feature/article_detail/presentation/viewmodel/article_detail_view_model.dart';
import 'package:english_reading_app/feature/article_detail/presentation/widget/article_detail_header.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_detail/presentation/view/word_detail_sheet.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_local_data_source.dart';
import 'package:english_reading_app/product/services/user_service_export.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part '../widget/article_detail_appbar.dart';

class ArticleDetailView extends StatelessWidget {
  final ArticleModel? article;
  const ArticleDetailView({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArticleDetailViewModel()..setArticle(article),
      child: const _ArticleDetailViewBody(),
    );
  }
}

class _ArticleDetailViewBody extends StatelessWidget {
  const _ArticleDetailViewBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleDetailViewModel>(
      builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: const _NewsDetailAppBar(),
          extendBody: true,
          body: Padding(
            padding: context.paddingHorizAllLow * 1.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: context.cMediumValue),
                  const ArticleDetailHeader(),
                  SizedBox(height: context.cMediumValue),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: viewmodel.fontSize,
                        height: 2.5,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children:
                          TextSpanBuilder(
                            fullText: viewmodel.article?.text ?? '',
                            context: context,
                            fontSize: viewmodel.fontSize,
                            onWordTap: (word) async {
                              _showWordDetailSheet(context, word);
                            },
                          ).build(),
                    ),
                  ),
                  SizedBox(height: context.dynamicHeight(0.15)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWordDetailSheet(BuildContext context, String word) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder:
          (context) => ChangeNotifierProvider(
            create:
                (_) => WordDetailViewModel(
                  WordDetailRepositoryImpl(
                    remoteDataSource: WordDetailRemoteDataSourceImpl(
                      Dio(),
                      FirebaseServiceImpl<DictionaryEntry>(
                        firestore: FirebaseFirestore.instance,
                      ),
                    ),
                    localDataSource: WordDetailLocalDataSourceImpl(),
                    networkInfo: NetworkInfo(InternetConnectionChecker()),
                  ),
                  UserServiceImpl(),
                  NetworkInfo(InternetConnectionChecker()),
                ),
            child: WordDetailSheet(
              word: word,
              source: WordDetailSource.api,
              onWordSaved: () {
                _refreshWordBank(context);
              },
            ),
          ),
    );
  }

  Future<void> _refreshWordBank(BuildContext context) async {
    try {
      final wordBankProvider = Provider.of<WordBankViewModel>(
        context,
        listen: false,
      );
      await wordBankProvider.fetchWords();
    } catch (e) {
      debugPrint('Word bank provider bulunamadı: $e');
    }
  }
}
