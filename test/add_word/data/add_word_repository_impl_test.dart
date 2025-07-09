import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:english_reading_app/feature/add_word/data/repository/add_word_repository_impl.dart';
import 'package:english_reading_app/feature/add_word/data/datasource/add_word_remote_data_source.dart';
import 'package:english_reading_app/product/services/auth_service.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/core/error/failure.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_word_repository_impl_test.mocks.dart';

@GenerateMocks([
  AddWordRemoteDataSource,
  AuthService,
  User,
])
void main() {
  late AddWordRepositoryImpl addWordRepositoryImpl;
  late MockAddWordRemoteDataSource mockAddWordRemoteDataSource;
  late MockAuthService mockAuthService;
  late MockUser mockUser;

  setUp(
    () {
      mockAddWordRemoteDataSource = MockAddWordRemoteDataSource();
      mockAuthService = MockAuthService();
      mockUser = MockUser();
      addWordRepositoryImpl = AddWordRepositoryImpl(
        remoteDataSource: mockAddWordRemoteDataSource,
        authService: mockAuthService,
      );
    },
  );

  group(
    'succes/fail test add word repository impl save word with authenticated user',
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
      const testUserId = 'test_user_id';
      final testDictionaryEntryWithUserId = testDictionaryEntry.copyWith(
        userId: testUserId,
      );
      final savedDictionaryEntry = testDictionaryEntryWithUserId.copyWith(
        documentId: 'test_document_id',
      );

      test(
        'succes test',
        () async {
          //arrange
          when(mockAuthService.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(testUserId);
          when(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId))
              .thenAnswer((_) async => savedDictionaryEntry);
          //act
          final result = await addWordRepositoryImpl.saveWord(testDictionaryEntry);
          //assert
          // ignore: inference_failure_on_instance_creation
          expect(result, Right(savedDictionaryEntry));
          verify(mockAuthService.currentUser);
          verify(mockUser.uid);
          verify(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId));
          verifyNoMoreInteractions(mockAddWordRemoteDataSource);
          verifyNoMoreInteractions(mockAuthService);
        },
      );

      test(
        'fail test server exception',
        () async {
          //arrange
          when(mockAuthService.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(testUserId);
          when(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId))
              .thenThrow(ServerException('Server error occurred'));
          //act
          final result = await addWordRepositoryImpl.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(failure.errorMessage, 'Server error occurred');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAuthService.currentUser);
          verify(mockUser.uid);
          verify(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId));
          verifyNoMoreInteractions(mockAddWordRemoteDataSource);
          verifyNoMoreInteractions(mockAuthService);
        },
      );

      test(
        'fail test connection exception',
        () async {
          //arrange
          when(mockAuthService.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(testUserId);
          when(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId))
              .thenThrow(ConnectionException('Connection error occurred'));
          //act
          final result = await addWordRepositoryImpl.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ConnectionFailure>());
              expect(failure.errorMessage, 'Connection error occurred');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAuthService.currentUser);
          verify(mockUser.uid);
          verify(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId));
          verifyNoMoreInteractions(mockAddWordRemoteDataSource);
          verifyNoMoreInteractions(mockAuthService);
        },
      );

      test(
        'fail test unknown exception',
        () async {
          //arrange
          when(mockAuthService.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(testUserId);
          when(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId))
              .thenThrow(UnKnownException('Unknown error occurred'));
          //act
          final result = await addWordRepositoryImpl.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<UnKnownFaliure>());
              expect(failure.errorMessage, 'Unknown error occurred');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAuthService.currentUser);
          verify(mockUser.uid);
          verify(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId));
          verifyNoMoreInteractions(mockAddWordRemoteDataSource);
          verifyNoMoreInteractions(mockAuthService);
        },
      );

      test(
        'fail test generic exception',
        () async {
          //arrange
          when(mockAuthService.currentUser).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(testUserId);
          when(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId))
              .thenThrow(Exception('Generic error occurred'));
          //act
          final result = await addWordRepositoryImpl.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<UnKnownFaliure>());
              expect(failure.errorMessage, 'Exception: Generic error occurred');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAuthService.currentUser);
          verify(mockUser.uid);
          verify(mockAddWordRemoteDataSource.saveWord(testDictionaryEntryWithUserId));
          verifyNoMoreInteractions(mockAddWordRemoteDataSource);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
    },
  );

  group(
    'succes/fail test add word repository impl save word with unauthenticated user',
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

      test(
        'fail test no authenticated user',
        () async {
          //arrange
          when(mockAuthService.currentUser).thenReturn(null);
          //act
          final result = await addWordRepositoryImpl.saveWord(testDictionaryEntry);
          //assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<UnKnownFaliure>());
              expect(failure.errorMessage, 'Kullanıcı oturum açmamış');
            },
            (_) => fail('Should not reach here'),
          );
          verify(mockAuthService.currentUser);
          verifyNoMoreInteractions(mockAddWordRemoteDataSource);
          verifyNoMoreInteractions(mockAuthService);
        },
      );
    },
  );
}
