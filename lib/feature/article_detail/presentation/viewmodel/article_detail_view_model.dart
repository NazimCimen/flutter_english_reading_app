import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';

class ArticleDetailViewModel extends ChangeNotifier {
  double _fontSize = 16;
  double get fontSize => _fontSize;
  ArticleModel? _article;
  ArticleModel? get article => _article;

  void setArticle(ArticleModel? article) {
    _article = article;
    notifyListeners();
  }

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}
