import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:english_reading_app/product/model/article_model.dart';

import 'home_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
  DocumentSnapshot,
])
void main() {
  late HomeRemoteDataSourceImpl dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockDoc;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockQuery = MockQuery<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    dataSource = HomeRemoteDataSourceImpl(firestore: mockFirestore);
  });

  group('success/fail test getArticles', () {
    final testArticleData = {
      'title': 'Test Article',
      'content': 'Test content',
      'category': 'test',
      'imageUrl': 'https://test.com/image.jpg',
      'createdAt': Timestamp.now(),
      'articleId': 'test_id',
    };

    test('success test should return list of articles when fetch is successful', () async {
      //arrange
      when(mockFirestore.collection('articles')).thenReturn(mockCollection);
      when(mockCollection.orderBy('createdAt', descending: true)).thenReturn(mockQuery);
      when(mockQuery.limit(10)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockDoc]);
      when(mockDoc.data()).thenReturn(testArticleData);

      //act
      final result = await dataSource.getArticles();

      //assert
      expect(result, isA<List<ArticleModel>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Article');
      verify(mockFirestore.collection('articles'));
      verify(mockCollection.orderBy('createdAt', descending: true));
    });

    test('success test should filter by category when categoryFilter is provided', () async {
      //arrange
      when(mockFirestore.collection('articles')).thenReturn(mockCollection);
      when(mockCollection.orderBy('createdAt', descending: true)).thenReturn(mockQuery);
      when(mockQuery.limit(10)).thenReturn(mockQuery);
      when(mockQuery.where('category', isEqualTo: 'tech')).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockDoc]);
      when(mockDoc.data()).thenReturn(testArticleData);

      //act
      final result = await dataSource.getArticles(categoryFilter: 'tech');

      //assert
      expect(result, isA<List<ArticleModel>>());
      verify(mockQuery.where('category', isEqualTo: 'tech'));
    });

    test('success test should return empty list when no articles found', () async {
      //arrange
      when(mockFirestore.collection('articles')).thenReturn(mockCollection);
      when(mockCollection.orderBy('createdAt', descending: true)).thenReturn(mockQuery);
      when(mockQuery.limit(10)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([]);

      //act
      final result = await dataSource.getArticles();

      //assert
      expect(result, isEmpty);
      verify(mockFirestore.collection('articles'));
    });

    test('fail test should throw ServerException when FirebaseException occurs', () async {
      //arrange
      when(mockFirestore.collection('articles')).thenReturn(mockCollection);
      when(mockCollection.orderBy('createdAt', descending: true)).thenReturn(mockQuery);
      when(mockQuery.limit(10)).thenReturn(mockQuery);
      when(mockQuery.get()).thenThrow(FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Network error',
        code: 'network-error',
      ));

      //act & assert
      expect(
        () => dataSource.getArticles(),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw ServerException when general exception occurs', () async {
      //arrange
      when(mockFirestore.collection('articles')).thenReturn(mockCollection);
      when(mockCollection.orderBy('createdAt', descending: true)).thenReturn(mockQuery);
      when(mockQuery.limit(10)).thenReturn(mockQuery);
      when(mockQuery.get()).thenThrow(Exception('Generic error'));

      //act & assert
      expect(
        () => dataSource.getArticles(),
        throwsA(isA<ServerException>()),
      );
    });

    test('fail test should throw UnKnownException when unknown error occurs', () async {
      //arrange
      when(mockFirestore.collection('articles')).thenReturn(mockCollection);
      when(mockCollection.orderBy('createdAt', descending: true)).thenReturn(mockQuery);
      when(mockQuery.limit(10)).thenReturn(mockQuery);
      when(mockQuery.get()).thenThrow('Unknown error');

      //act & assert
      expect(
        () => dataSource.getArticles(),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('success/fail test resetPagination', () {
    test('success test should reset pagination state', () {
      //arrange
      //act
      dataSource.resetPagination();

      //assert
      // Since resetPagination is void and resets internal state,
      // we can't directly test it, but we can verify it doesn't throw
      expect(() => dataSource.resetPagination(), returnsNormally);
    });
  });
} 