import 'package:get_it/get_it.dart';
import 'package:english_reading_app/feature/add_word/data/datasource/add_word_remote_data_source.dart';
import 'package:english_reading_app/feature/add_word/data/repository/add_word_repository_impl.dart';
import 'package:english_reading_app/feature/add_word/domain/repository/add_word_repository.dart';
import 'package:english_reading_app/feature/add_word/domain/usecase/save_word_usecase.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';

final getIt = GetIt.instance;

void initAddWordModule() {
  // Data Source
  getIt.registerLazySingleton<AddWordRemoteDataSource>(
    () => AddWordRemoteDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AddWordRepository>(
    () => AddWordRepositoryImpl(
      remoteDataSource: getIt(),
      authService: getIt(),
    ),
  );

  // Use Case
  getIt.registerLazySingleton<SaveWordUseCase>(
    () => SaveWordUseCase(getIt()),
  );

  // ViewModel
  getIt.registerFactory<AddWordViewModel>(
    () => AddWordViewModel(getIt()),
  );
} 