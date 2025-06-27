part of '../view/word_bank_view.dart';

class _SwipeStackCardView extends StatelessWidget {
  final List<DictionaryEntry> words;
  const _SwipeStackCardView({required this.words, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingAllMedium,
      child: CardSwiper(
        cardsCount: words.length,
        numberOfCardsDisplayed: 3,
        backCardOffset: const Offset(0, 20),
        padding: EdgeInsets.zero,
        isLoop: false,
        allowedSwipeDirection: AllowedSwipeDirection.only(
          up: true,
          down: true,
          left: true,
          right: true,
        ),
        cardBuilder: (context, index, percentX, percentY) {
          final word = words[index];
          return _SwipeWordCard(word: word);
        },
      ),
    );
  }
} 