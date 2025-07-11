import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';
import 'package:english_reading_app/product/model/article_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ArticleModel>> getArticles({
    String? categoryFilter,
    int limit = 10,
    bool reset = false,
  });

  void resetPagination();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSourceImpl({required this.firestore});

  DocumentSnapshot? _lastDocument;

  @override
  Future<List<ArticleModel>> getArticles({
    String? categoryFilter,
    int limit = 10,
    bool reset = false,
  }) async {
    try {
      if (reset) _lastDocument = null;

      Query query = firestore
          .collection(FirebaseCollectionEnum.articles.name)
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
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Firebase error occurred');
    } on Exception catch (e) {
      throw ServerException('Failed to fetch articles: $e');
    } catch (e) {
      throw UnKnownException('Unknown error occurred: $e');
    }
  }

  @override
  void resetPagination() {
    _lastDocument = null;
  }
}
