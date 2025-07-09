import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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

final getIt = GetIt.instance;

void setupDI() {
  // Core/Shared
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  getIt.registerLazySingleton<INetworkInfo>(() => NetworkInfo(getIt()));
  getIt.registerLazySingleton<BaseFirebaseService<DictionaryEntry>>(
    () => FirebaseServiceImpl<DictionaryEntry>(firestore: getIt()),
  );
  getIt.registerLazySingleton<UserService>(() => UserServiceImpl());
  getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());

  // AddWord Feature
  getIt.registerLazySingleton<AddWordRemoteDataSource>(
    () => AddWordRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AddWordRepository>(
    () => AddWordRepositoryImpl(
      remoteDataSource: getIt(),
      authService: getIt(),
    ),
  );
  getIt.registerLazySingleton<SaveWordUseCase>(
    () => SaveWordUseCase(getIt()),
  );
  getIt.registerFactory<AddWordViewModel>(
    () => AddWordViewModel(getIt()),
  );
} 