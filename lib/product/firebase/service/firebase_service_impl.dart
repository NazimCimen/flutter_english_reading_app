import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/constants/app_durations.dart';
import 'package:english_reading_app/product/firebase/model/base_firebase_model.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';

class FirebaseServiceImpl<T extends BaseFirebaseModel<T>>
    implements BaseFirebaseService<T> {
  final FirebaseFirestore firestore;
  FirebaseServiceImpl({required this.firestore});
  @override
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
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection(collectionPath)
          .orderBy(dateFieldName, descending: descending)
          .limit(limit);

      // Son dokümandan itibaren devam et
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Tarih aralığı filtresi
      if (startDate != null) {
        query = query.where(dateFieldName, isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where(dateFieldName, isLessThanOrEqualTo: endDate);
      }

      // Ek filtreler
      if (additionalConditions != null) {
        additionalConditions.forEach((key, value) {
          query = query.where(key, isEqualTo: value);
        });
      }

      final querySnapshot = await query.get().timeout(
        AppDurations.timeoutDuration,
        onTimeout: () => throw TimeoutException('timeout'),
      );

      return querySnapshot.docs
          .map((doc) => model.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Hata yönetimi
      rethrow;
    }
  }

  /// Sayfalama için son dokümanı almak için yardımcı metod
  @override
  Future<DocumentSnapshot?> getLastDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      return await firestore
          .collection(collectionPath)
          .doc(docId)
          .get()
          .timeout(
            AppDurations.timeoutDuration,
            onTimeout: () => throw TimeoutException('timeout'),
          );
    } catch (e) {
      rethrow;
    }
  }

  /// TO SAVE ITEM IN FIRESTORE
  @override
  Future<void> setItem(String collectionPath, T item) async {
    await firestore
        .collection(collectionPath)
        .doc(item.id)
        .set(item.toJson())
        .timeout(
          AppDurations.timeoutDuration,
          onTimeout: () {
            throw TimeoutException('timeout');
          },
        );
  }

  /// TO UPDATE ITEM IN FIRESTORE
  @override
  Future<void> updateItem(String collectionPath, String docId, T item) async {
    await firestore
        .collection(collectionPath)
        .doc(docId)
        .update(item.toJson())
        .timeout(
          AppDurations.timeoutDuration,
          onTimeout: () {
            throw TimeoutException('timeout');
          },
        );
  }

  /// TO DELETE ITEM IN FIRESTORE
  @override
  Future<void> deleteItem(String collectionPath, String docId) async {
    await firestore
        .collection(collectionPath)
        .doc(docId)
        .delete()
        .timeout(
          AppDurations.timeoutDuration,
          onTimeout: () {
            throw TimeoutException('timeout');
          },
        );
  }

  /// TO DELETE ITEM SUB COLLECTIONS IN FIRESTORE
  @override
  Future<void> deleteSubCollections(List<String> subCollections) async {
    for (final subCol in subCollections) {
      final snapshots = await firestore.collection(subCol).get();
      for (final doc in snapshots.docs) {
        await doc.reference.delete().timeout(
          AppDurations.timeoutDuration,
          onTimeout: () {
            throw TimeoutException('timeout');
          },
        );
      }
    }
  }

  /// TO GET ITEM FROM FIRETORE
  @override
  Future<T> getItem({
    required String collectionPath,
    required String docId,
    required T model,
  }) async {
    final snapshot = await firestore
        .collection(collectionPath)
        .doc(docId)
        .get()
        .timeout(
          AppDurations.timeoutDuration,
          onTimeout: () {
            throw TimeoutException('timeout');
          },
        );
    final data = snapshot.data();
    if (data == null) {
      throw ServerException('Data not found');
    }
    //try-catch mekanizması uygulanmalı
    final item = model.fromJson(data);
    return item;
  }

  @override
  Future<List<T>> queryItems({
    required String collectionPath,
    required Map<String, dynamic> conditions,
    required T model,
    String? orderBy,
  }) async {
    try {
      // İlk sorguyu oluştur
      Query<Map<String, dynamic>> query = firestore.collection(collectionPath);

      // Şartları zincirle
      for (final condition in conditions.entries) {
        query = query.where(condition.key, isEqualTo: condition.value);
      }

      // Sıralama varsa ekle
      if (orderBy != null) {
        query = query.orderBy(orderBy);
      }

      // Sorguyu çalıştır
      final querySnapshot = await query.get().timeout(
        AppDurations.timeoutDuration,
        onTimeout: () => throw TimeoutException('timeout'),
      );

      // Boş liste kontrolü
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // Model dönüşümü
      return querySnapshot.docs
          .map((doc) => model.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Hata yönetimi
      rethrow; // Hataları dışarı fırlatıyoruz, isterseniz log ekleyebilirsiniz.
    }
  }

  /// TO GET ALL ITEMS FROM A COLLECTION IN FIRESTORE
  @override
  Future<List<T>> getAllItems({
    required String collectionPath,
    required T model,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection(collectionPath)
          .get()
          .timeout(
            AppDurations.timeoutDuration,
            onTimeout: () => throw TimeoutException('timeout'),
          );

      // Eğer koleksiyon boşsa, boş bir liste döner
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // Belgeleri modele dönüştürüp döndürür
      return querySnapshot.docs
          .map((doc) => model.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Hata yönetimi
      rethrow; // Hataları dışarı fırlatıyoruz, isterseniz log ekleyebilirsiniz.
    }
  }

  @override
  Stream<T> listenAndGetItem({
    required String collectionPath,
    required String docId,
    required T model,
  }) {
    return firestore
        .collection(collectionPath)
        .doc(docId)
        .snapshots()
        .where((snapshot) {
          return snapshot.metadata.hasPendingWrites == false;
        })
        .map((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            if (data == null) {
              throw ServerException('Data not found');
            }
            final item = model.fromJson(data as Map<String, dynamic>);
            return item;
          } else {
            throw ServerException('Document does not exist');
          }
        });
  }
}
