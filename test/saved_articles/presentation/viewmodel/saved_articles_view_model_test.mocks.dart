// Mocks generated by Mockito 5.4.5 from annotations
// in english_reading_app/test/saved_articles/presentation/viewmodel/saved_articles_view_model_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:dartz/dartz.dart' as _i2;
import 'package:english_reading_app/core/connection/network_info.dart' as _i9;
import 'package:english_reading_app/core/error/failure.dart' as _i6;
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart'
    as _i4;
import 'package:english_reading_app/product/model/article_model.dart' as _i7;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i3;
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

/// A class which mocks [SavedArticlesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSavedArticlesRepository extends _i1.Mock
    implements _i4.SavedArticlesRepository {
  MockSavedArticlesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.ArticleModel>>> getSavedArticles({
    int? limit,
    _i8.DocumentSnapshot<Object?>? lastDocument,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSavedArticles,
          [],
          {
            #limit: limit,
            #lastDocument: lastDocument,
          },
        ),
        returnValue:
            _i5.Future<_i2.Either<_i6.Failure, List<_i7.ArticleModel>>>.value(
                _FakeEither_0<_i6.Failure, List<_i7.ArticleModel>>(
          this,
          Invocation.method(
            #getSavedArticles,
            [],
            {
              #limit: limit,
              #lastDocument: lastDocument,
            },
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.ArticleModel>>>);

  @override
  _i5.Future<_i2.Either<_i6.Failure, void>> saveArticle(
          _i7.ArticleModel? article) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveArticle,
          [article],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, void>>.value(
            _FakeEither_0<_i6.Failure, void>(
          this,
          Invocation.method(
            #saveArticle,
            [article],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, void>>);

  @override
  _i5.Future<_i2.Either<_i6.Failure, void>> removeArticle(String? articleId) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeArticle,
          [articleId],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, void>>.value(
            _FakeEither_0<_i6.Failure, void>(
          this,
          Invocation.method(
            #removeArticle,
            [articleId],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, void>>);

  @override
  _i5.Future<_i2.Either<_i6.Failure, bool>> isArticleSaved(String? articleId) =>
      (super.noSuchMethod(
        Invocation.method(
          #isArticleSaved,
          [articleId],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, bool>>.value(
            _FakeEither_0<_i6.Failure, bool>(
          this,
          Invocation.method(
            #isArticleSaved,
            [articleId],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, bool>>);

  @override
  _i5.Future<_i2.Either<_i6.Failure, Set<String>>> getSavedArticleIds() =>
      (super.noSuchMethod(
        Invocation.method(
          #getSavedArticleIds,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, Set<String>>>.value(
            _FakeEither_0<_i6.Failure, Set<String>>(
          this,
          Invocation.method(
            #getSavedArticleIds,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, Set<String>>>);

  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.ArticleModel>>>
      searchSavedArticles(String? query) => (super.noSuchMethod(
            Invocation.method(
              #searchSavedArticles,
              [query],
            ),
            returnValue: _i5
                .Future<_i2.Either<_i6.Failure, List<_i7.ArticleModel>>>.value(
                _FakeEither_0<_i6.Failure, List<_i7.ArticleModel>>(
              this,
              Invocation.method(
                #searchSavedArticles,
                [query],
              ),
            )),
          ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.ArticleModel>>>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i9.NetworkInfo {
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
