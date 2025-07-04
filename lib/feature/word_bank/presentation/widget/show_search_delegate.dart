import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_tile.dart';
import 'package:flutter/material.dart';

class WordBankSearchDelegate extends SearchDelegate<void> {
  final WordBankViewModel viewmodel;
  WordBankSearchDelegate(this.viewmodel);

  @override
  Widget? buildLeading(BuildContext context) {
    return Container(
      margin: context.paddingAllLow,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.borderRadiusAllMedium,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: IconButton(
        onPressed: () => close(context, null),
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Container(
        margin: context.paddingAllLow,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: context.borderRadiusAllMedium,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.clear_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => close(context, null),
        ),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: viewmodel.searchWords(query),
      builder: (context, snapshot) {
        return Padding(
          padding: context.cPaddingSmall,
          child: ListView.builder(
            itemCount:
                viewmodel.searchedWords != null
                    ? viewmodel.searchedWords!.length
                    : 0,
            itemBuilder: (context, index) {
              if (viewmodel.searchedWords != null) {
                return WordTile(word: viewmodel.searchedWords![index]);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: viewmodel.searchWords(query),
      builder: (context, snapshot) {
        return Padding(
          padding: context.cPaddingSmall,
          child: ListView.builder(
            itemCount:
                viewmodel.searchedWords != null
                    ? viewmodel.searchedWords!.length
                    : 0,
            itemBuilder: (context, index) {
              if (viewmodel.searchedWords != null) {
                return WordTile(word: viewmodel.searchedWords![index]);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }
}
