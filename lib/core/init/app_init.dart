import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:english_reading_app/config/theme/theme_manager.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:english_reading_app/di/di_container.dart';
import 'package:english_reading_app/feature/home/presentation/viewmodel/home_view_model.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/feature/profile/viewmodel/profile_view_model.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/saved_articles/data/repository/saved_articles_repository_impl.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_remote_data_source.dart';
import 'package:english_reading_app/feature/saved_articles/data/datasource/saved_articles_local_data_source.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/core/connection/network_info.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_local_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/datasource/word_detail_remote_data_source.dart';
import 'package:english_reading_app/feature/word_detail/data/repository/word_detail_repository_impl.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/product/services/user_service_impl.dart';
import 'package:english_reading_app/product/firebase/service/firebase_service_impl.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:english_reading_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/main.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/config/localization/locale_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppInit {
  Future<void> initialize();
  Future<void> run();
  Widget getApp();
}

class AppInitImpl extends AppInit {
  @override
  Widget getApp() {
    return EasyLocalization(
      supportedLocales: const [
        LocaleConstants.enLocale,
        //   LocaleConstants.trLocale,
      ],
      path: LocaleConstants.localePath,
      fallbackLocale: LocaleConstants.enLocale,

      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeManager>(
            create: (context) => ThemeManager(),
          ),

          ChangeNotifierProvider<WordBankViewModel>(
            create: (context) => getIt<WordBankViewModel>(),
          ),
          ChangeNotifierProvider<WordDetailViewModel>(
            create:
                (context) => WordDetailViewModel(
                  WordDetailRepositoryImpl(
                    remoteDataSource: WordDetailRemoteDataSourceImpl(
                      Dio(),
                      FirebaseServiceImpl<DictionaryEntry>(
                        firestore: FirebaseFirestore.instance,
                      ),
                    ),
                    localDataSource: WordDetailLocalDataSourceImpl(),
                    networkInfo: NetworkInfo(InternetConnectionChecker()),
                  ),
                  UserServiceImpl(),
                  NetworkInfo(InternetConnectionChecker()),
                ),
          ),
          ChangeNotifierProvider<AddWordViewModel>(
            create: (context) => getIt<AddWordViewModel>(),
          ),
          ChangeNotifierProvider<ProfileViewModel>(
            create: (context) => ProfileViewModel(),
          ),
          ChangeNotifierProvider<MainLayoutViewModel>(
            create: (context) => MainLayoutViewModel(),
          ),
          ChangeNotifierProvider<HomeViewModel>(
            create: (context) {
              // Saved Articles Dependencies
              final networkInfo = NetworkInfo(InternetConnectionChecker());
              final savedArticlesRemoteDataSource =
                  SavedArticlesRemoteDataSourceImpl();
              final savedArticlesLocalDataSource =
                  SavedArticlesLocalDataSourceImpl();

              // Saved Articles Repository
              final savedArticlesRepository = SavedArticlesRepositoryImpl(
                remoteDataSource: savedArticlesRemoteDataSource,
                localDataSource: savedArticlesLocalDataSource,
                networkInfo: networkInfo,
              );

              return HomeViewModel(
                savedArticlesRepository: savedArticlesRepository,
              );
            },
          ),
          ChangeNotifierProvider<SavedArticlesViewModel>(
            create: (context) {
              // Saved Articles Dependencies
              final networkInfo = NetworkInfo(InternetConnectionChecker());
              final savedArticlesRemoteDataSource =
                  SavedArticlesRemoteDataSourceImpl();
              final savedArticlesLocalDataSource =
                  SavedArticlesLocalDataSourceImpl();

              // Saved Articles Repository
              final savedArticlesRepository = SavedArticlesRepositoryImpl(
                remoteDataSource: savedArticlesRemoteDataSource,
                localDataSource: savedArticlesLocalDataSource,
                networkInfo: networkInfo,
              );

              return SavedArticlesViewModel(
                repository: savedArticlesRepository,
                networkInfo: networkInfo,
              );
            },
          ),
        ],
        child: const MyApp(),
      ),
    );
  }

  @override
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    setupDI();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await ThemeManager().loadTheme();
  }

  @override
  Future<void> run() async {
    await initialize();
    runApp(getApp());
  }
}
