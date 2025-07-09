import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_remote_data_source.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_articles_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  FirebaseAuth,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  Query,
  User,
  WriteBatch,
  QueryDocumentSnapshot,
])
void main() {
  late SavedArticlesRemoteDataSourceImpl dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockWriteBatch mockBatch;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockQuery = MockQuery<Map<String, dynamic>>();
    mockBatch = MockWriteBatch();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    
    // Setup default auth behavior
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-user-id');
    
    // Setup default firestore behavior
    when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc('test-user-id')).thenReturn(mockDocumentReference);
    when(mockDocumentReference.collection('saved_articles')).thenReturn(mockCollectionReference);
    when(mockFirestore.batch()).thenReturn(mockBatch);
    
    dataSource = SavedArticlesRemoteDataSourceImpl(
      firestore: mockFirestore,
      auth: mockAuth,
    );
  });

  final tArticles = [
    const ArticleModel(
      articleId: '1',
      title: 'Test Article 1',
      text: 'Test content 1',
    ),
    const ArticleModel(
      articleId: '2',
      title: 'Test Article 2',
      text: 'Test content 2',
    ),
  ];

  final tArticle = const ArticleModel(
    articleId: '1',
    title: 'Test Article',
    text: 'Test content',
  );

  const tArticleId = '1';
  final tArticleIds = <String>{'1', '2', '3'};

  // Helper method to create mock documents
  List<MockQueryDocumentSnapshot<Map<String, dynamic>>> _createMockDocuments(List<ArticleModel> articles) {
    return articles.map((article) {
      final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(mockDoc.data()).thenReturn(article.toJson());
      when(mockDoc.id).thenReturn(article.articleId ?? '');
      return mockDoc;
    }).toList();
  }

  // Helper method to create mock documents for article IDs
  List<MockQueryDocumentSnapshot<Map<String, dynamic>>> _createMockDocumentsForIds(Set<String> ids) {
    return ids.map((id) {
      final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(mockDoc.id).thenReturn(id);
      return mockDoc;
    }).toList();
  }

  group('success test get saved articles', () {
    test('success test should return articles when firestore call is successful', () async {
      //arrange
      final mockDocs = _createMockDocuments(tArticles);
      when(mockCollectionReference.orderBy('savedAt', descending: true))
          .thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      //act
      final result = await dataSource.getSavedArticles();

      //assert
      expect(result, tArticles);
      verify(mockCollectionReference.orderBy('savedAt', descending: true));
      verify(mockQuery.get());
    });

    test('success test should return articles with limit and last document when provided', () async {
      //arrange
      const limit = 10;
      final lastDocument = MockDocumentSnapshot<Map<String, dynamic>>();
      final mockDocs = _createMockDocuments(tArticles);
      when(mockCollectionReference.orderBy('savedAt', descending: true))
          .thenReturn(mockQuery);
      when(mockQuery.startAfterDocument(lastDocument)).thenReturn(mockQuery);
      when(mockQuery.limit(limit)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      //act
      final result = await dataSource.getSavedArticles(limit: limit, lastDocument: lastDocument);

      //assert
      expect(result, tArticles);
      verify(mockCollectionReference.orderBy('savedAt', descending: true));
      verify(mockQuery.startAfterDocument(lastDocument));
      verify(mockQuery.limit(limit));
      verify(mockQuery.get());
    });
  });

  group('fail test get saved articles', () {
    test('fail test should throw server exception when user is not authenticated', () async {
      //arrange
      when(mockAuth.currentUser).thenReturn(null);

      //act & assert
      expect(() => dataSource.getSavedArticles(), throwsA(isA<ServerException>()));
    });

    test('fail test should throw server exception when firestore throws exception', () async {
      //arrange
      when(mockCollectionReference.orderBy('savedAt', descending: true))
          .thenThrow(ServerException('Firestore error'));

      //act & assert
      expect(() => dataSource.getSavedArticles(), throwsA(isA<ServerException>()));
    });
  });

  group('success test save article', () {
    test('success test should save article when firestore call is successful', () async {
      //arrange
      when(mockCollectionReference.doc(tArticleId)).thenReturn(mockDocumentReference);
      when(mockBatch.set(any, any)).thenReturn(mockBatch);
      when(mockBatch.update(any, any)).thenReturn(mockBatch);
      when(mockBatch.commit()).thenAnswer((_) async {});

      //act
      await dataSource.saveArticle(tArticle);

      //assert
      verify(mockBatch.set(any, any));
      verify(mockBatch.update(any, any));
      verify(mockBatch.commit());
    });
  });

  group('fail test save article', () {
    test('fail test should throw server exception when user is not authenticated', () async {
      //arrange
      when(mockAuth.currentUser).thenReturn(null);

      //act & assert
      expect(() => dataSource.saveArticle(tArticle), throwsA(isA<ServerException>()));
    });

    test('fail test should throw server exception when article id is null', () async {
      //arrange
      final articleWithoutId = const ArticleModel(
        title: 'Test Article',
        text: 'Test content',
      );

      //act & assert
      expect(() => dataSource.saveArticle(articleWithoutId), throwsA(isA<ServerException>()));
    });
  });

  group('success test remove article', () {
    test('success test should remove article when firestore call is successful', () async {
      //arrange
      when(mockCollectionReference.doc(tArticleId)).thenReturn(mockDocumentReference);
      when(mockBatch.delete(any)).thenReturn(mockBatch);
      when(mockBatch.update(any, any)).thenReturn(mockBatch);
      when(mockBatch.commit()).thenAnswer((_) async {});

      //act
      await dataSource.removeArticle(tArticleId);

      //assert
      verify(mockBatch.delete(any));
      verify(mockBatch.update(any, any));
      verify(mockBatch.commit());
    });
  });

  group('fail test remove article', () {
    test('fail test should throw server exception when user is not authenticated', () async {
      //arrange
      when(mockAuth.currentUser).thenReturn(null);

      //act & assert
      expect(() => dataSource.removeArticle(tArticleId), throwsA(isA<ServerException>()));
    });
  });

  group('success test is article saved', () {
    test('success test should return true when article exists', () async {
      //arrange
      final mockDocs = _createMockDocumentsForIds(tArticleIds);
      when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      //act
      final result = await dataSource.isArticleSaved(tArticleId);

      //assert
      expect(result, true);
      verify(mockCollectionReference.get());
    });

    test('success test should return false when article does not exist', () async {
      //arrange
      final mockDocs = _createMockDocumentsForIds(<String>{});
      when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      //act
      final result = await dataSource.isArticleSaved(tArticleId);

      //assert
      expect(result, false);
      verify(mockCollectionReference.get());
    });
  });

  group('fail test is article saved', () {
    test('fail test should throw server exception when user is not authenticated', () async {
      //arrange
      when(mockAuth.currentUser).thenReturn(null);

      //act & assert
      expect(() => dataSource.isArticleSaved(tArticleId), throwsA(isA<ServerException>()));
    });
  });

  group('success test get saved article ids', () {
    test('success test should return article ids when firestore call is successful', () async {
      //arrange
      final mockDocs = _createMockDocumentsForIds(tArticleIds);
      when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      //act
      final result = await dataSource.getSavedArticleIds();

      //assert
      expect(result, tArticleIds);
      verify(mockCollectionReference.get());
    });
  });

  group('fail test get saved article ids', () {
    test('fail test should throw server exception when user is not authenticated', () async {
      //arrange
      when(mockAuth.currentUser).thenReturn(null);

      //act & assert
      expect(() => dataSource.getSavedArticleIds(), throwsA(isA<ServerException>()));
    });
  });

  group('success test search saved articles', () {
    test('success test should return articles when firestore call is successful', () async {
      //arrange
      const query = 'test';
      final mockDocs = _createMockDocuments(tArticles);
      when(mockCollectionReference.orderBy('savedAt', descending: true))
          .thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      //act
      final result = await dataSource.searchSavedArticles(query);

      //assert
      expect(result, tArticles);
      verify(mockCollectionReference.orderBy('savedAt', descending: true));
      verify(mockQuery.get());
    });

    test('success test should return empty list when query is empty', () async {
      //arrange
      const query = '';

      //act
      final result = await dataSource.searchSavedArticles(query);

      //assert
      expect(result, isEmpty);
      verifyNever(mockCollectionReference.orderBy(any));
    });
  });

  group('fail test search saved articles', () {
    test('fail test should throw server exception when user is not authenticated', () async {
      //arrange
      const query = 'test';
      when(mockAuth.currentUser).thenReturn(null);

      //act & assert
      expect(() => dataSource.searchSavedArticles(query), throwsA(isA<ServerException>()));
    });
  });
} 