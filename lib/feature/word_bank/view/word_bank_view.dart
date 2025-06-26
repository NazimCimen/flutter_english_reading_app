import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/view/deneme.dart';
import 'package:english_reading_app/feature/word_bank/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_bank/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

part '../widget/word_tile.dart';

class WordBankView extends StatelessWidget {
  const WordBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WordBankViewmodel>();

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.white),
        automaticallyImplyLeading: false,
        title: const Text('Word Bank'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Deneme()),
              );
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

      body:
          provider.words.isEmpty
              ? Center(child: Text('No words saved.'))
              : provider.viewMode == WordViewMode.list
              ? ListView.builder(
                itemCount: provider.words.length,
                itemBuilder: (context, index) {
                  final word = provider.words[index];
                  return _WordTile(word: word);
                },
              )
              : SafeArea(child: SwipeStackCardView(words: provider.words)),
    );
  }
}

class SwipeStackCardView extends StatelessWidget {
  final List<WordModel> words;
  const SwipeStackCardView({required this.words, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: CardSwiper(
        cardsCount: words.length,
        numberOfCardsDisplayed: 3,
        backCardOffset: const Offset(0, 20),
        padding: EdgeInsets.zero,
        isLoop: false,
        allowedSwipeDirection: AllowedSwipeDirection.only(up: true, down: true, left: true, right: true),
        cardBuilder: (context, index, percentX, percentY) {
          final word = words[index];
          return _SwipeWordCard(word: word);
        },
      ),
    );
  }
}

class _SwipeWordCard extends StatelessWidget {
  final WordModel word;
  const _SwipeWordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewmodel>();

    return Card(
      elevation: 12,
      color: AppColors.primaryColorSoft,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              word.word,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              word.definition ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () {
                    NavigatorService.pushNamed(
                      AppRoutes.addWordView,
                      arguments: word,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () => provider.deleteWord(word.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
