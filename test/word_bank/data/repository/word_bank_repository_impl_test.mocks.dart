// Mocks generated by Mockito 5.4.5 from annotations
// in english_reading_app/test/word_bank/data/repository/word_bank_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:io' as _i13;

import 'package:dartz/dartz.dart' as _i2;
import 'package:english_reading_app/core/connection/network_info.dart' as _i10;
import 'package:english_reading_app/core/error/failure.dart' as _i7;
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_local_data_source.dart'
    as _i9;
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_remote_data_source.dart'
    as _i4;
import 'package:english_reading_app/product/model/dictionary_entry.dart' as _i6;
import 'package:english_reading_app/product/model/user_model.dart' as _i12;
import 'package:english_reading_app/product/services/user_service.dart' as _i11;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeInternetConnectionChecker_1 extends _i1.SmartFake
    implements _i3.InternetConnectionChecker {
  _FakeInternetConnectionChecker_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WordBankRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordBankRemoteDataSource extends _i1.Mock
    implements _i4.WordBankRemoteDataSource {
  MockWordBankRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<_i6.DictionaryEntry>> getWords({
    required String? userId,
    int? limit = 10,
    bool? reset = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getWords,
          [],
          {
            #userId: userId,
            #limit: limit,
            #reset: reset,
          },
        ),
        returnValue: _i5.Future<List<_i6.DictionaryEntry>>.value(
            <_i6.DictionaryEntry>[]),
      ) as _i5.Future<List<_i6.DictionaryEntry>>);

  @override
  _i5.Future<_i2.Either<_i7.Failure, List<_i6.DictionaryEntry>?>> searchWord(
          {required String? query}) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchWord,
          [],
          {#query: query},
        ),
        returnValue: _i5
            .Future<_i2.Either<_i7.Failure, List<_i6.DictionaryEntry>?>>.value(
            _FakeEither_0<_i7.Failure, List<_i6.DictionaryEntry>?>(
          this,
          Invocation.method(
            #searchWord,
            [],
            {#query: query},
          ),
        )),
      ) as _i5.Future<_i2.Either<_i7.Failure, List<_i6.DictionaryEntry>?>>);

  @override
  _i5.Future<String> addWord(_i6.DictionaryEntry? word) => (super.noSuchMethod(
        Invocation.method(
          #addWord,
          [word],
        ),
        returnValue: _i5.Future<String>.value(_i8.dummyValue<String>(
          this,
          Invocation.method(
            #addWord,
            [word],
          ),
        )),
      ) as _i5.Future<String>);

  @override
  _i5.Future<void> updateWord(_i6.DictionaryEntry? word) => (super.noSuchMethod(
        Invocation.method(
          #updateWord,
          [word],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteWord(String? documentId) => (super.noSuchMethod(
        Invocation.method(
          #deleteWord,
          [documentId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [WordBankLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordBankLocalDataSource extends _i1.Mock
    implements _i9.WordBankLocalDataSource {
  MockWordBankLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<_i6.DictionaryEntry>> getWords() => (super.noSuchMethod(
        Invocation.method(
          #getWords,
          [],
        ),
        returnValue: _i5.Future<List<_i6.DictionaryEntry>>.value(
            <_i6.DictionaryEntry>[]),
      ) as _i5.Future<List<_i6.DictionaryEntry>>);

  @override
  _i5.Future<void> addWord(_i6.DictionaryEntry? word) => (super.noSuchMethod(
        Invocation.method(
          #addWord,
          [word],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateWord(_i6.DictionaryEntry? word) => (super.noSuchMethod(
        Invocation.method(
          #updateWord,
          [word],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteWord(String? documentId) => (super.noSuchMethod(
        Invocation.method(
          #deleteWord,
          [documentId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> clearWords() => (super.noSuchMethod(
        Invocation.method(
          #clearWords,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i10.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.InternetConnectionChecker get connectivity => (super.noSuchMethod(
        Invocation.getter(#connectivity),
        returnValue: _FakeInternetConnectionChecker_1(
          this,
          Invocation.getter(#connectivity),
        ),
      ) as _i3.InternetConnectionChecker);

  @override
  _i5.Future<bool> get currentConnectivityResult => (super.noSuchMethod(
        Invocation.getter(#currentConnectivityResult),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
}

/// A class which mocks [UserService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserService extends _i1.Mock implements _i11.UserService {
  MockUserService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool isUserSignIn() => (super.noSuchMethod(
        Invocation.method(
          #isUserSignIn,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<_i12.UserModel?> getUserById({required String? userId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserById,
          [],
          {#userId: userId},
        ),
        returnValue: _i5.Future<_i12.UserModel?>.value(),
      ) as _i5.Future<_i12.UserModel?>);

  @override
  _i5.Future<bool> setUserToFirestore() => (super.noSuchMethod(
        Invocation.method(
          #setUserToFirestore,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> updateUser(_i12.UserModel? model) => (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [model],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> updatePassword({required String? newPassword}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePassword,
          [],
          {#newPassword: newPassword},
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> reAuthenticateUser({required String? currentPassword}) =>
      (super.noSuchMethod(
        Invocation.method(
          #reAuthenticateUser,
          [],
          {#currentPassword: currentPassword},
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<String?> uploadProfileImage({required _i13.File? imageFile}) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadProfileImage,
          [],
          {#imageFile: imageFile},
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<bool> updateProfileImage({required String? imageUrl}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateProfileImage,
          [],
          {#imageUrl: imageUrl},
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
}
