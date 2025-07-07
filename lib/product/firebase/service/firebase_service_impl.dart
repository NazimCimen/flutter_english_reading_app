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
    String dateFieldName = 'createdAt', // Default date field
    bool descending = true, // Default: newest records first
    Map<String, dynamic>? additionalConditions,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection(collectionPath)
          .orderBy(dateFieldName, descending: descending)
          .limit(limit);

      // Continue from the last document
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Date range filter
      if (startDate != null) {
        query = query.where(dateFieldName, isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where(dateFieldName, isLessThanOrEqualTo: endDate);
      }

      // Additional filters
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
      // Error handling
      rethrow;
    }
  }

  /// Helper method to get the last document for pagination
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

  /// TO ADD ITEM WITH AUTO-GENERATED ID IN FIRESTORE
  @override
  Future<String> addItem(String collectionPath, T item) async {
    final docRef = await firestore
        .collection(collectionPath)
        .add(item.toJson())
        .timeout(
          AppDurations.timeoutDuration,
          onTimeout: () {
            throw TimeoutException('timeout');
          },
        );
    return docRef.id;
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
      // Create initial query
      Query<Map<String, dynamic>> query = firestore.collection(collectionPath);

      // Chain conditions
      for (final condition in conditions.entries) {
        query = query.where(condition.key, isEqualTo: condition.value);
      }

      // Add ordering if specified
      if (orderBy != null) {
        query = query.orderBy(orderBy);
      }

      // Execute query
      final querySnapshot = await query.get().timeout(
        AppDurations.timeoutDuration,
        onTimeout: () => throw TimeoutException('timeout'),
      );

      // Empty list check
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // Model conversion - add documentId
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['documentId'] = doc.id; // Add Firestore document ID
        return model.fromJson(data);
      }).toList();
    } catch (e) {
      // Error handling
      rethrow; // We throw errors to the outside, you can add logging if needed.
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

      // If collection is empty, return empty list
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // Convert documents to models and return - add documentId
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['documentId'] = doc.id; // Add Firestore document ID
        return model.fromJson(data);
      }).toList();
    } catch (e) {
      // Error handling
      rethrow; // We throw errors to the outside, you can add logging if needed.
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
