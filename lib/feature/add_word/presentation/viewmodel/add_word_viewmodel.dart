import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class AddWordViewModel extends ChangeNotifier {
  List<Meaning> _meanings = [];
  List<Meaning> get meanings => _meanings;

  void setMeanings(List<Meaning> meaning) {
    _meanings = meaning;
    notifyListeners();
  }

  void addNewMeaning() {
    _meanings.insert(
      0,
      Meaning(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        partOfSpeech: ' ',
        definitions: [Definition(definition: '', example: '')],
      ),
    );

    notifyListeners();
  }

  void cleanMeanings() {
    _meanings = [];
    notifyListeners();
  }

  void removeMeaning(Meaning meaning) {
    _meanings.remove(meaning);
    notifyListeners();
  }

  void removeMeaningById(String id) {
    _meanings.removeWhere((meaning) => meaning.id == id);
    notifyListeners();
  }

  void updateMeaning(Meaning meaning) {
    _meanings.remove(meaning);
    notifyListeners();
  }
}
