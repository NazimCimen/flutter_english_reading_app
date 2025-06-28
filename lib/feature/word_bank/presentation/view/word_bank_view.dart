import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_detail/presentation/view/word_detail_sheet.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_local_data_source.dart';
import 'package:english_reading_app/services/dictionary_service.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part '../widget/word_tile.dart';
part '../widget/app_bar.dart';
part '../widget/word_bank_detail_sheet.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _AppBar(
        searchController: _searchController,
        isSearching: _isSearching,
        onSearchChanged: _onSearchChanged,
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, WordBankViewmodel provider) {
    if (provider.isLoading) {
      return _buildLoadingView(context);
    }

    return _buildPagedListView(context, provider);
  }

  Widget _buildPagedListView(BuildContext context, WordBankViewmodel provider) {
    return PagedListView<int, DictionaryEntry>(
      pagingController: provider.pagingController,
      padding: EdgeInsets.only(
        top: context.cMediumValue,
        left: context.cLowValue,
        right: context.cLowValue,
        bottom: context.cXxLargeValue * 3,
      ),
      builderDelegate: PagedChildBuilderDelegate<DictionaryEntry>(
        itemBuilder: (context, word, index) => _WordTile(word: word),
        firstPageProgressIndicatorBuilder: (context) => _buildLoadingView(context),
        newPageProgressIndicatorBuilder: (context) => _buildLoadingMoreIndicator(context),
        noItemsFoundIndicatorBuilder: (context) => _buildEmptyView(context),
        firstPageErrorIndicatorBuilder: (context) => _buildErrorView(context, provider),
        newPageErrorIndicatorBuilder: (context) => _buildErrorView(context, provider),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return ListView.builder(
      padding: context.paddingAllMedium,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: context.cMediumValue),
          padding: context.paddingAllMedium,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: context.borderRadiusAllMedium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: context.cLowValue),
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMoreIndicator(BuildContext context) {
    return Container(
      padding: context.paddingAllMedium,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: context.cMediumValue,
              height: context.cMediumValue,
              child: CircularProgressIndicator(
                strokeWidth: context.cLowValue / 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(width: context.cLowValue),
            Text(
              'Daha fazla kelime yükleniyor...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: context.paddingAllLarge,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_outline,
              size: 64,
              color: AppColors.primaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: context.cLargeValue),
          Text(
            'Henüz kelime kaydetmediniz',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.cLowValue),
          Text(
            'Makalelerde kelimelerin üzerine tıklayarak\nkelime bankasına ekleyebilirsiniz',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          SizedBox(height: context.cXLargeValue),
          ElevatedButton.icon(
            onPressed: () => NavigatorService.pushNamed(AppRoutes.addWordView),
            icon: const Icon(Icons.add),
            label: const Text('Kelime Ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: context.cLargeValue,
                vertical: context.cMediumValue,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: context.borderRadiusAllMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, WordBankViewmodel provider) {
    return Container(
      padding: context.paddingAllLarge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: context.cMediumValue),
          Text(
            'Bir hata oluştu',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: context.cLowValue),
          ElevatedButton(
            onPressed: () => provider.refreshWords(),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  void _showWordDetailSheet(BuildContext context, String word) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => WordDetailViewModel(
          WordDetailRepositoryImpl(
            remoteDataSource: WordDetailRemoteDataSourceImpl(
              DictionaryServiceImpl(Dio()),
            ),
            localDataSource: WordDetailLocalDataSourceImpl(
              FirebaseServiceImpl<DictionaryEntry>(
                firestore: FirebaseFirestore.instance,
              ),
            ),
          ),
        ),
        child: WordDetailSheet(
          word: word,
          source: WordDetailSource.local, // Local'dan veri al
          onWordSaved: () {
            // Word bank'ı yenile
            final wordBankProvider = Provider.of<WordBankViewmodel>(
              context, 
              listen: false,
            );
            wordBankProvider.fetchWords();
          },
        ),
      ),
    );
  }
}
