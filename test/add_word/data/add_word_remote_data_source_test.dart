import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_reading_app/feature/add_word/data/datasource/add_word_remote_data_source.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/error/exception.dart';

import 'add_word_remote_data_source_test.mocks.dart';

@GenerateMocks([
  BaseFirebaseService,
])
void main() {
  late AddWordRemoteDataSourceImpl addWordRemoteDataSourceImpl;
  late MockBaseFirebaseService mockBaseFirebaseService;

  setUp(
    () {
      mockBaseFirebaseService = MockBaseFirebaseService<DictionaryEntry>();
      addWordRemoteDataSourceImpl = AddWordRemoteDataSourceImpl(
        mockBaseFirebaseService,
      );
    },
  );

  group(
    'succes/fail test add word remote data source impl save word to firebase',
    () {
      const testWord = 'test';
      final testMeanings = [
        Meaning(
          partOfSpeech: 'noun',
          definitions: [Definition(definition: 'test definition')],
        ),
      ];
      final testDictionaryEntry = DictionaryEntry(
        word: testWord,
        meanings: testMeanings,
        createdAt: DateTime.now(),
      );
      const testCollectionPath = 'user_words';

      test(
        'succes test',
        () async {
          //arrange
          when(
            mockBaseFirebaseService.addItem(
              testCollectionPath,
              testDictionaryEntry,
            ),
          ).thenAnswer(
            (_) async => 'test_document_id',
          );
          //act
          final result = await addWordRemoteDataSourceImpl.saveWord(
            testDictionaryEntry,
          );
          //assert
          expect(result.documentId, 'test_document_id');
          expect(result.word, testWord);
          verify(
            mockBaseFirebaseService.addItem(
              testCollectionPath,
              testDictionaryEntry,
            ),
          );
          verifyNoMoreInteractions(mockBaseFirebaseService);
        },
      );

      test(
        'fail test',
        () async {
          //arrange
          when(
            mockBaseFirebaseService.addItem(
              testCollectionPath,
              testDictionaryEntry,
            ),
          ).thenThrow(
            ServerException('Server error occurred'),
          );
          //act
          //assert
          expect(
            () => addWordRemoteDataSourceImpl.saveWord(testDictionaryEntry),
            throwsA(isA<ServerException>()),
          );
          verify(
            mockBaseFirebaseService.addItem(
              testCollectionPath,
              testDictionaryEntry,
            ),
          );
          verifyNoMoreInteractions(mockBaseFirebaseService);
        },
      );
    },
  );

  group(
    'succes/fail test add word remote data source impl update word in firebase',
    () {
      const testWord = 'test';
      final testMeanings = [
        Meaning(
          partOfSpeech: 'noun',
          definitions: [Definition(definition: 'test definition')],
        ),
      ];
      final testDictionaryEntry = DictionaryEntry(
        documentId: 'test_document_id',
        word: testWord,
        meanings: testMeanings,
        createdAt: DateTime.now(),
      );
      const testCollectionPath = 'user_words';

      test(
        'succes test',
        () async {
          //arrange
          when(
            mockBaseFirebaseService.updateItem(
              testCollectionPath,
              'test_document_id',
              testDictionaryEntry,
            ),
          ).thenAnswer(
            (_) async => null,
          );
          //act
          final result = await addWordRemoteDataSourceImpl.updateWord(
            testDictionaryEntry,
          );
          //assert
          expect(result, true);
          verify(
            mockBaseFirebaseService.updateItem(
              testCollectionPath,
              'test_document_id',
              testDictionaryEntry,
            ),
          );
          verifyNoMoreInteractions(mockBaseFirebaseService);
        },
      );

      test(
        'fail test',
        () async {
          //arrange
          when(
            mockBaseFirebaseService.updateItem(
              testCollectionPath,
              'test_document_id',
              testDictionaryEntry,
            ),
          ).thenThrow(
            ServerException('Update failed'),
          );
          //act
          //assert
          expect(
            () => addWordRemoteDataSourceImpl.updateWord(testDictionaryEntry),
            throwsA(isA<ServerException>()),
          );
          verify(
            mockBaseFirebaseService.updateItem(
              testCollectionPath,
              'test_document_id',
              testDictionaryEntry,
            ),
          );
          verifyNoMoreInteractions(mockBaseFirebaseService);
        },
      );
    },
  );

  group(
    'succes/fail test add word remote data source impl delete word from firebase',
    () {
      const testDocumentId = 'test_document_id';
      const testCollectionPath = 'user_words';

      test(
        'succes test',
        () async {
          //arrange
          when(
            mockBaseFirebaseService.deleteItem(
              testCollectionPath,
              testDocumentId,
            ),
          ).thenAnswer(
            (_) async => null,
          );
          //act
          final result = await addWordRemoteDataSourceImpl.deleteWord(
            testDocumentId,
          );
          //assert
          expect(result, true);
          verify(
            mockBaseFirebaseService.deleteItem(
              testCollectionPath,
              testDocumentId,
            ),
          );
          verifyNoMoreInteractions(mockBaseFirebaseService);
        },
      );

      test(
        'fail test',
        () async {
          //arrange
          when(
            mockBaseFirebaseService.deleteItem(
              testCollectionPath,
              testDocumentId,
            ),
          ).thenThrow(
            ServerException('Delete failed'),
          );
          //act
          //assert
          expect(
            () => addWordRemoteDataSourceImpl.deleteWord(testDocumentId),
            throwsA(isA<ServerException>()),
          );
          verify(
            mockBaseFirebaseService.deleteItem(
              testCollectionPath,
              testDocumentId,
            ),
          );
          verifyNoMoreInteractions(mockBaseFirebaseService);
        },
      );
    },
  );
}
