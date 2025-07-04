import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_bank/presentation/widget/word_tile.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordBankSearchDelegate extends SearchDelegate<void> {
  WordBankSearchDelegate();
  List<DictionaryEntry> searchedWords2 = [];

  
  Future<void> searchWords(String query) async {
    searchedWords2 = [DictionaryEntry(word: 'sffds')];
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_outlined),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchWords(query),
      builder: (context, snapshot) {
        return Text(query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchWords(query),
      builder: (context, snapshot) {
        return Text(
          searchedWords2.isNotEmpty ? searchedWords2.first.word! : 'yok',
        );
      },
    );
  }
}
