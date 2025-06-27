import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/article_detail/presentation/widget/word_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

part '../widget/word_tile.dart';
part '../widget/swipe_stack_card_view.dart';
part '../widget/swipe_word_card.dart';

// WordDetailSheet'i part dosyasında kullanabilmek için global olarak tanımla
WordDetailSheet createWordDetailSheet(String word, {VoidCallback? onWordSaved}) => 
    WordDetailSheet(word: word, onWordSaved: onWordSaved);

class WordBankView extends StatelessWidget {
  const WordBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordBankViewmodel>(context, listen: true);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.white),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.bookmark_rounded,
              color: AppColors.white,
              size: 24,
            ),
            SizedBox(width: context.cLowValue),
            Text(
              'Kelime Bankası',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshWords();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
            
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () => NavigatorService.pushNamed(AppRoutes.addWordView),
          ),
          IconButton(
            icon: Icon(
              provider.viewMode == WordViewMode.list
                  ? Icons.view_carousel
                  : Icons.view_list,
            ),
            onPressed: () => provider.toggleViewMode(),
          ),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, WordBankViewmodel provider) {
    if (provider.isLoading) {
      return _buildLoadingView(context);
    }

    if (provider.words.isEmpty) {
      return _buildEmptyView(context);
    }

    return provider.viewMode == WordViewMode.list
        ? _buildListView(context, provider)
        : _buildCardView(context, provider);
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
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

  Widget _buildListView(BuildContext context, WordBankViewmodel provider) {
    return ListView.builder(
      padding: context.paddingAllMedium,
      itemCount: provider.words.length,
      itemBuilder: (context, index) {
        final word = provider.words[index];
        return _WordTile(word: word);
      },
    );
  }

  Widget _buildCardView(BuildContext context, WordBankViewmodel provider) {
    return SafeArea(
      child: _SwipeStackCardView(words: provider.words),
    );
  }
}
