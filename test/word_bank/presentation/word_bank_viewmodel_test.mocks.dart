// Mocks generated by Mockito 5.4.5 from annotations
// in english_reading_app/test/word_bank/presentation/word_bank_viewmodel_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:english_reading_app/core/error/failure.dart' as _i6;
import 'package:english_reading_app/feature/word_bank/domain/usecase/add_word_to_bank_usecase.dart'
    as _i9;
import 'package:english_reading_app/feature/word_bank/domain/usecase/delete_word_from_bank_usecase.dart'
    as _i11;
import 'package:english_reading_app/feature/word_bank/domain/usecase/get_words_usecase.dart'
    as _i4;
import 'package:english_reading_app/feature/word_bank/domain/usecase/search_words_usecase.dart'
    as _i8;
import 'package:english_reading_app/feature/word_bank/domain/usecase/update_word_in_bank_usecase.dart'
    as _i10;
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart'
    as _i2;
import 'package:english_reading_app/product/model/dictionary_entry.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;

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

class _FakeWordBankRepository_0 extends _i1.SmartFake
    implements _i2.WordBankRepository {
  _FakeWordBankRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetWordsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetWordsUseCase extends _i1.Mock implements _i4.GetWordsUseCase {
  MockGetWordsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WordBankRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeWordBankRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.WordBankRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.DictionaryEntry>>> call({
    int? limit = 10,
    bool? reset = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
          {
            #limit: limit,
            #reset: reset,
          },
        ),
        returnValue: _i5
            .Future<_i3.Either<_i6.Failure, List<_i7.DictionaryEntry>>>.value(
            _FakeEither_1<_i6.Failure, List<_i7.DictionaryEntry>>(
          this,
          Invocation.method(
            #call,
            [],
            {
              #limit: limit,
              #reset: reset,
            },
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i7.DictionaryEntry>>>);
}

/// A class which mocks [SearchWordsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSearchWordsUseCase extends _i1.Mock
    implements _i8.SearchWordsUseCase {
  MockSearchWordsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WordBankRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeWordBankRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.WordBankRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.DictionaryEntry>?>> call(
          String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [query],
        ),
        returnValue: _i5
            .Future<_i3.Either<_i6.Failure, List<_i7.DictionaryEntry>?>>.value(
            _FakeEither_1<_i6.Failure, List<_i7.DictionaryEntry>?>(
          this,
          Invocation.method(
            #call,
            [query],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i7.DictionaryEntry>?>>);
}

/// A class which mocks [AddWordToBankUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockAddWordToBankUseCase extends _i1.Mock
    implements _i9.AddWordToBankUseCase {
  MockAddWordToBankUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WordBankRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeWordBankRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.WordBankRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, String>> call(_i7.DictionaryEntry? word) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [word],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, String>>.value(
            _FakeEither_1<_i6.Failure, String>(
          this,
          Invocation.method(
            #call,
            [word],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, String>>);
}

/// A class which mocks [UpdateWordInBankUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockUpdateWordInBankUseCase extends _i1.Mock
    implements _i10.UpdateWordInBankUseCase {
  MockUpdateWordInBankUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WordBankRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeWordBankRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.WordBankRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, void>> call(_i7.DictionaryEntry? word) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [word],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [word],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [DeleteWordFromBankUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeleteWordFromBankUseCase extends _i1.Mock
    implements _i11.DeleteWordFromBankUseCase {
  MockDeleteWordFromBankUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WordBankRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeWordBankRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.WordBankRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, void>> call(String? documentId) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [documentId],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [documentId],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}
