import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';
//final BaseFirebaseService<ArticleModel>

// FirebaseServiceImpl<ArticleModel>(firestore: FirebaseFirestore.instance);
class ArticleService {
  final _firebase = FirebaseFirestore.instance;
  final String _collectionPath = FirebaseCollectionEnum.articles.name;

  DocumentSnapshot? _lastDocument;
  DocumentSnapshot? get lastDocument => _lastDocument;
  Future<List<ArticleModel>> getArticles({
    String? categoryFilter,
    int limit = 10,
    bool reset = false,
  }) async {
    try {
      if (reset) _lastDocument = null;

      Query query = _firebase
          .collection(_collectionPath)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (categoryFilter != null &&
          categoryFilter.isNotEmpty &&
          categoryFilter.toLowerCase() != 'all') {
        query = query.where('category', isEqualTo: categoryFilter);
      }

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      }

      return querySnapshot.docs
          .map(
            (doc) => const ArticleModel().fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e, stack) {
      return [];
    }
  }

  /// Sayfalamayı sıfırlar
  void resetPagination() {
    _lastDocument = null;
  }
}
