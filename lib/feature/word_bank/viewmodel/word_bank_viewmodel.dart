import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/feature/word_bank/word_model.dart';
import 'package:flutter/material.dart';
enum WordViewMode { list, cards }

class WordBankViewmodel extends ChangeNotifier {
  WordViewMode _viewMode = WordViewMode.list;

  WordViewMode get viewMode => _viewMode;

  void toggleViewMode() {
    _viewMode =
        _viewMode == WordViewMode.list ? WordViewMode.cards : WordViewMode.list;
    notifyListeners();
  }

  final String userId = '12345';
  List<WordModel> _words = [
    WordModel(
      id: '1',
      word: 'apple',
      definition: 'a fruit that is red or green',
      tag: '',
      tagColor: '',
    ),
    WordModel(
      id: '2',
      word: 'book',
      definition: 'a set of written or printed pages',
    ),
    WordModel(
      id: '3',
      word: 'sun',
      definition: 'the star at the center of our solar system',
    ),
    WordModel(
      id: '1',
      word: 'apple',
      definition: 'a fruit that is red or green',
    ),
    WordModel(
      id: '2',
      word: 'book',
      definition: 'a set of written or printed pages',
    ),
    WordModel(
      id: '3',
      word: 'sun',
      definition: 'the star at the center of our solar system',
    ),
  ];
  List<WordModel> get words => _words;

  WordBankViewmodel();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchWords() async {
    final snapshot =
        await firestore
            .collection('users')
            .doc(userId)
            .collection('word_bank')
            .get();
    _words =
        snapshot.docs
            .map((doc) => WordModel.fromJson(doc.data(), doc.id))
            .toList();
    notifyListeners();
  }

  Future<void> addWord(String word, {String? definition}) async {
    final docRef = await firestore
        .collection('users')
        .doc(userId)
        .collection('word_bank')
        .add({'word': word, 'definition': definition});
    _words.add(WordModel(id: docRef.id, word: word, definition: definition));
    notifyListeners();
  }

  Future<void> updateWord(WordModel word) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('word_bank')
        .doc(word.id)
        .update(word.toJson());
    final index = _words.indexWhere((w) => w.id == word.id);
    if (index != -1) {
      _words[index] = word;
      notifyListeners();
    }
  }

  Future<void> deleteWord(String id) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('word_bank')
        .doc(id)
        .delete();
    _words.removeWhere((w) => w.id == id);
    notifyListeners();
  }
}
