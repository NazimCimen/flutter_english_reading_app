import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:english_reading_app/product/firebase/service/base_firebase_service.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/services/auth_service.dart';
import 'package:english_reading_app/product/services/user_service.dart';
import 'package:english_reading_app/product/services/user_service_impl.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/feature/add_word/data/datasource/add_word_remote_data_source.dart';
import 'package:english_reading_app/feature/add_word/data/repository/add_word_repository_impl.dart';
import 'package:english_reading_app/feature/add_word/domain/repository/add_word_repository.dart';
import 'package:english_reading_app/feature/add_word/domain/usecase/save_word_usecase.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_remote_data_source.dart';
import 'package:english_reading_app/feature/word_bank/data/datasource/word_bank_local_data_source.dart';
import 'package:english_reading_app/feature/word_bank/data/repository/word_bank_repository_impl.dart';
import 'package:english_reading_app/feature/word_bank/domain/word_bank_repository.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/get_words_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/search_words_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/add_word_to_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/update_word_in_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/domain/usecase/delete_word_from_bank_usecase.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_remote_data_source.dart';
import 'package:english_reading_app/feature/saved_articles/data/repository/saved_articles_repository_impl.dart';
import 'package:english_reading_app/feature/saved_articles/domain/repository/saved_articles_repository.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/get_saved_articles_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/save_article_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/remove_article_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/is_article_saved_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/get_saved_article_ids_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/domain/usecase/search_saved_articles_usecase.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';
import 'package:english_reading_app/feature/word_detail/domain/repository/word_detail_repository.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_api_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_local_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/save_word_to_local_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/is_word_saved_usecase.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:english_reading_app/feature/home/data/repository/home_repository_impl.dart';
import 'package:english_reading_app/feature/home/domain/export.dart';
import 'package:english_reading_app/feature/home/presentation/viewmodel/home_view_model.dart';
import 'package:english_reading_app/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:english_reading_app/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:english_reading_app/feature/auth/domain/export.dart';
import 'package:english_reading_app/feature/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

final getIt = GetIt.instance;

void setupDI() {
  // Core/Shared Services
  getIt..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
  ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
  ..registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker())
  ..registerLazySingleton<INetworkInfo>(() => NetworkInfo(getIt<InternetConnectionChecker>()))
  ..registerLazySingleton<Dio>(() => Dio())
  
  // Firebase Service for DictionaryEntry
  ..registerLazySingleton<BaseFirebaseService<DictionaryEntry>>(
    () => FirebaseServiceImpl<DictionaryEntry>(firestore: getIt<FirebaseFirestore>()),
  )
  
  // User and Auth Services
  ..registerLazySingleton<UserService>(() => UserServiceImpl())
  ..registerLazySingleton<AuthService>(() => AuthServiceImpl())
  ..registerLazySingleton<GoogleSignIn>(() => GoogleSignIn())

  // AddWord Feature Dependencies
  ..registerLazySingleton<AddWordRemoteDataSource>(
    () => AddWordRemoteDataSourceImpl(getIt<BaseFirebaseService<DictionaryEntry>>()),
  )
  ..registerLazySingleton<AddWordRepository>(
    () => AddWordRepositoryImpl(
      remoteDataSource: getIt<AddWordRemoteDataSource>(),
      authService: getIt<AuthService>(),
    ),
  )
  ..registerLazySingleton<SaveWordUseCase>(
    () => SaveWordUseCase(repository: getIt<AddWordRepository>()),
  )
  ..registerFactory<AddWordViewModel>(
    () => AddWordViewModel(getIt<SaveWordUseCase>()),
  )

  // WordBank Feature Dependencies
  ..registerLazySingleton<WordBankRemoteDataSource>(
    () => WordBankRemoteDataSourceImpl(
      firebaseService: getIt<BaseFirebaseService<DictionaryEntry>>(),
    ),
  )
  ..registerLazySingleton<WordBankLocalDataSource>(
    () => WordBankLocalDataSourceImpl(),
  )
  ..registerLazySingleton<WordBankRepository>(
    () => WordBankRepositoryImpl(
      remoteDataSource: getIt<WordBankRemoteDataSource>(),
      localDataSource: getIt<WordBankLocalDataSource>(),
      networkInfo: getIt<INetworkInfo>() as NetworkInfo,
      userService: getIt<UserService>(),
    ),
  )
  ..registerLazySingleton<GetWordsUseCase>(
    () => GetWordsUseCase(repository: getIt<WordBankRepository>()),
  )
  ..registerLazySingleton<SearchWordsUseCase>(
    () => SearchWordsUseCase(repository: getIt<WordBankRepository>()),
  )
  ..registerLazySingleton<AddWordToBankUseCase>(
    () => AddWordToBankUseCase(repository: getIt<WordBankRepository>()),
  )
  ..registerLazySingleton<UpdateWordInBankUseCase>(
    () => UpdateWordInBankUseCase(repository: getIt<WordBankRepository>()),
  )
  ..registerLazySingleton<DeleteWordFromBankUseCase>(
    () => DeleteWordFromBankUseCase(repository: getIt<WordBankRepository>()),
  )
  ..registerFactory<WordBankViewModel>(
    () => WordBankViewModel(
      getWordsUseCase: getIt<GetWordsUseCase>(),
      searchWordsUseCase: getIt<SearchWordsUseCase>(),
      addWordToBankUseCase: getIt<AddWordToBankUseCase>(),
      updateWordInBankUseCase: getIt<UpdateWordInBankUseCase>(),
      deleteWordFromBankUseCase: getIt<DeleteWordFromBankUseCase>(),
    ),
  )

  // SavedArticles Feature Dependencies
  ..registerLazySingleton<SavedArticlesRemoteDataSource>(
    () => SavedArticlesRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
    ),
  )
  ..registerLazySingleton<SavedArticlesRepository>(
    () => SavedArticlesRepositoryImpl(
      remoteDataSource: getIt<SavedArticlesRemoteDataSource>(),
      networkInfo: getIt<INetworkInfo>() as NetworkInfo,
    ),
  )
  ..registerLazySingleton<GetSavedArticlesUseCase>(
    () => GetSavedArticlesUseCase(getIt<SavedArticlesRepository>()),
  )
  ..registerLazySingleton<SaveArticleUseCase>(
    () => SaveArticleUseCase(getIt<SavedArticlesRepository>()),
  )
  ..registerLazySingleton<RemoveArticleUseCase>(
    () => RemoveArticleUseCase(getIt<SavedArticlesRepository>()),
  )
  ..registerLazySingleton<IsArticleSavedUseCase>(
    () => IsArticleSavedUseCase(getIt<SavedArticlesRepository>()),
  )
  ..registerLazySingleton<GetSavedArticleIdsUseCase>(
    () => GetSavedArticleIdsUseCase(getIt<SavedArticlesRepository>()),
  )
  ..registerLazySingleton<SearchSavedArticlesUseCase>(
    () => SearchSavedArticlesUseCase(getIt<SavedArticlesRepository>()),
  )
  ..registerFactory<SavedArticlesViewModel>(
    () => SavedArticlesViewModel(
      repository: getIt<SavedArticlesRepository>(),
      networkInfo: getIt<INetworkInfo>() as NetworkInfo,
    ),
  )

  // Home Feature Dependencies
  ..registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  )
  ..registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
    ),
  )
  ..registerLazySingleton<GetArticlesUseCase>(
    () => GetArticlesUseCase(repository: getIt<HomeRepository>()),
  )
  ..registerLazySingleton<ResetPaginationUseCase>(
    () => ResetPaginationUseCase(repository: getIt<HomeRepository>()),
  )
  ..registerFactory<HomeViewModel>(
    () => HomeViewModel(
      getArticlesUseCase: getIt<GetArticlesUseCase>(),
      resetPaginationUseCase: getIt<ResetPaginationUseCase>(),
      savedArticlesRepository: getIt<SavedArticlesRepository>(),
    ),
  )

  // WordDetail Feature Dependencies
  ..registerLazySingleton<WordDetailRemoteDataSource>(
    () => WordDetailRemoteDataSourceImpl(
      getIt<Dio>(),
      getIt<BaseFirebaseService<DictionaryEntry>>(),
    ),
  )
  ..registerLazySingleton<WordDetailRepository>(
    () => WordDetailRepositoryImpl(
      remoteDataSource: getIt<WordDetailRemoteDataSource>(),
      networkInfo: getIt<INetworkInfo>() as NetworkInfo,
    ),
  )
  ..registerLazySingleton<GetWordDetailFromApiUseCase>(
    () => GetWordDetailFromApiUseCase(getIt<WordDetailRepository>()),
  )
  ..registerLazySingleton<GetWordDetailFromLocalUseCase>(
    () => GetWordDetailFromLocalUseCase(getIt<WordDetailRepository>()),
  )
  ..registerLazySingleton<SaveWordToLocalUseCase>(
    () => SaveWordToLocalUseCase(getIt<WordDetailRepository>()),
  )
  ..registerLazySingleton<IsWordSavedUseCase>(
    () => IsWordSavedUseCase(getIt<WordDetailRepository>()),
  )
  ..registerFactory<WordDetailViewModel>(
    () => WordDetailViewModel(
      getWordDetailFromApiUseCase: getIt<GetWordDetailFromApiUseCase>(),
      getWordDetailFromLocalUseCase: getIt<GetWordDetailFromLocalUseCase>(),
      saveWordToLocalUseCase: getIt<SaveWordToLocalUseCase>(),
      isWordSavedUseCase: getIt<IsWordSavedUseCase>(),
      userService: getIt<UserService>(),
    ),
  )

  // Auth Feature Dependencies
  ..registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
      userService: getIt<UserService>(),
    ),
  )
  ..registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  )
  ..registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerLazySingleton<SendEmailVerificationUseCase>(
    () => SendEmailVerificationUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerLazySingleton<CheckEmailVerificationUseCase>(
    () => CheckEmailVerificationUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerLazySingleton<SendPasswordResetEmailUseCase>(
    () => SendPasswordResetEmailUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerLazySingleton<SaveUserToFirestoreUseCase>(
    () => SaveUserToFirestoreUseCase(repository: getIt<AuthRepository>()),
  )
  ..registerFactory<AuthViewModel>(
    () => AuthViewModel(
      signupUseCase: getIt<SignupUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      sendEmailVerificationUseCase: getIt<SendEmailVerificationUseCase>(),
      checkEmailVerificationUseCase: getIt<CheckEmailVerificationUseCase>(),
      sendPasswordResetEmailUseCase: getIt<SendPasswordResetEmailUseCase>(),
      saveUserToFirestoreUseCase: getIt<SaveUserToFirestoreUseCase>(),
    ),
  );
} 