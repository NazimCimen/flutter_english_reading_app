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
import 'package:english_reading_app/feature/word_detail/domain/usecase/get_word_detail_from_firestore_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/save_word_to_local_usecase.dart';
import 'package:english_reading_app/feature/word_detail/domain/usecase/is_word_saved_usecase.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/feature/home/presentation/viewmodel/home_view_model.dart';
import 'package:english_reading_app/feature/profile/data/datasource/profile_remote_data_source.dart';
import 'package:english_reading_app/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:english_reading_app/feature/profile/domain/repository/profile_repository.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/update_password_usecase.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/update_username_usecase.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/update_profile_image_usecase.dart';
import 'package:english_reading_app/feature/profile/domain/usecase/logout_usecase.dart';
import 'package:english_reading_app/feature/profile/presentation/viewmodel/profile_view_model.dart';

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

 
  ..registerLazySingleton<DeleteWordFromBankUseCase>(
    () => DeleteWordFromBankUseCase(repository: getIt<WordBankRepository>()),
  )
  ..registerFactory<WordBankViewModel>(
    () => WordBankViewModel(
      getWordsUseCase: getIt<GetWordsUseCase>(),
      searchWordsUseCase: getIt<SearchWordsUseCase>(),
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
  ..registerFactory<HomeViewModel>(
    () => HomeViewModel(
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
  ..registerLazySingleton<GetWordDetailFromFirestoreUseCase>(
    () => GetWordDetailFromFirestoreUseCase(getIt<WordDetailRepository>()),
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
      getWordDetailFromLocalUseCase: getIt<GetWordDetailFromFirestoreUseCase>(),
      saveWordToLocalUseCase: getIt<SaveWordToLocalUseCase>(),
      isWordSavedUseCase: getIt<IsWordSavedUseCase>(),
      userService: getIt<UserService>(),
    ),
  )

  // Profile Feature Dependencies
  ..registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  )
  ..registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  )
  ..registerLazySingleton<UpdatePasswordUseCase>(
    () => UpdatePasswordUseCase(getIt<ProfileRepository>()),
  )
  ..registerLazySingleton<UpdateUsernameUseCase>(
    () => UpdateUsernameUseCase(getIt<ProfileRepository>()),
  )
  ..registerLazySingleton<UpdateProfileImageUseCase>(
    () => UpdateProfileImageUseCase(getIt<ProfileRepository>()),
  )
  ..registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<ProfileRepository>()),
  )
  ..registerFactory<ProfileViewModel>(
    () => ProfileViewModel(
      updatePasswordUseCase: getIt<UpdatePasswordUseCase>(),
      updateUsernameUseCase: getIt<UpdateUsernameUseCase>(),
      updateProfileImageUseCase: getIt<UpdateProfileImageUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      userService: getIt<UserService>(),
    ),
  );
} 