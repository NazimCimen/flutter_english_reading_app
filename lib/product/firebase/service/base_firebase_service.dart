import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/product/firebase/model/base_firebase_model.dart';

abstract class BaseFirebaseService<T extends BaseFirebaseModel<T>> {
  Future<void> setItem(String collectionPath, T item);
  Future<String> addItem(String collectionPath, T item);
  Future<void> updateItem(String collectionPath, String docId, T item);
  Future<void> deleteItem(String collectionPath, String docId);
  Future<void> deleteSubCollections(List<String> subCollections);
  Future<T> getItem({
    required String collectionPath,
    required String docId,
    required T model,
  });

  Future<List<T>> queryItems({
    required String collectionPath,
    required Map<String, dynamic> conditions,
    required T model,
    String? orderBy,
  });
  Future<List<T>> getAllItems({
    required String collectionPath,
    required T model,
  });
  Stream<T> listenAndGetItem({
    required String collectionPath,
    required String docId,
    required T model,
  });
  Future<List<T>> getPaginatedItems({
    required String collectionPath,
    required T model,
    required int limit,
    DocumentSnapshot? lastDocument,
    DateTime? startDate,
    DateTime? endDate,
    String dateFieldName = 'createdAt', // Varsayılan tarih alanı
    bool descending = true, // Varsayılan: yeni kayıtlar önce
    Map<String, dynamic>? additionalConditions,
  });
  Future<DocumentSnapshot?> getLastDocument({
    required String collectionPath,
    required String docId,
  });
}
