import 'package:english_reading_app/feature/home/repository/article_service.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final ArticleService _articleService = ArticleService();

  Future<List<ArticleModel>> fetchArticles({
    required String? categoryFilter,
    int limit = 10,
    bool reset = false,
  }) async {
    return _articleService.getArticles(
      categoryFilter: categoryFilter,
      limit: 10,
      reset: reset,
    );
  }
}
