import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class AddWordViewModel extends ChangeNotifier {
  List<Meaning> _meanings = [];
  List<Meaning> get meanings => _meanings;

  void setMeanings(List<Meaning> meanings) {
    _meanings = meanings.map((meaning) {
      return meaning.copyWith(
        id: meaning.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }).toList();
    notifyListeners();
  }

  void addNewMeaning() {
    _meanings.insert(
      0,
      Meaning(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        partOfSpeech: '',
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

  void updateMeaningPartOfSpeech(String meaningId, String partOfSpeech) {
    final index = _meanings.indexWhere((meaning) => meaning.id == meaningId);
    if (index != -1) {
      _meanings[index] = _meanings[index].copyWith(partOfSpeech: partOfSpeech);
      notifyListeners();
    }
  }

  void updateDefinition(String meaningId, int definitionIndex, String definition) {
    final meaningIndex = _meanings.indexWhere((meaning) => meaning.id == meaningId);
    if (meaningIndex != -1) {
      final meaning = _meanings[meaningIndex];
      final updatedDefinitions = List<Definition>.from(meaning.definitions);
      if (definitionIndex < updatedDefinitions.length) {
        updatedDefinitions[definitionIndex] = updatedDefinitions[definitionIndex].copyWith(
          definition: definition,
        );
        _meanings[meaningIndex] = meaning.copyWith(definitions: updatedDefinitions);
        notifyListeners();
      }
    }
  }

  void addDefinitionToMeaning(String meaningId) {
    final index = _meanings.indexWhere((meaning) => meaning.id == meaningId);
    if (index != -1) {
      final meaning = _meanings[index];
      final updatedDefinitions = List<Definition>.from(meaning.definitions);
      updatedDefinitions.add(Definition(definition: '', example: ''));
      _meanings[index] = meaning.copyWith(definitions: updatedDefinitions);
      notifyListeners();
    }
  }

  void removeDefinitionFromMeaning(String meaningId, int definitionIndex) {
    final meaningIndex = _meanings.indexWhere((meaning) => meaning.id == meaningId);
    if (meaningIndex != -1) {
      final meaning = _meanings[meaningIndex];
      if (meaning.definitions.length > 1) {
        final updatedDefinitions = List<Definition>.from(meaning.definitions);
        updatedDefinitions.removeAt(definitionIndex);
        _meanings[meaningIndex] = meaning.copyWith(definitions: updatedDefinitions);
        notifyListeners();
      }
    }
  }
}
