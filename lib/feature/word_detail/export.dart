/// Word Detail Feature Exports
/// This file provides a single entry point for all word detail feature components

// Domain Layer
/// Repository interfaces and business logic contracts
export 'domain/repository/word_detail_repository.dart';

/// Use cases for word detail operations
export 'domain/usecase/get_word_detail_from_api_usecase.dart';
export 'domain/usecase/get_word_detail_from_firestore_usecase.dart';
export 'domain/usecase/save_word_to_local_usecase.dart';
export 'domain/usecase/is_word_saved_usecase.dart';

// Data Layer
/// Remote data source implementations
export 'data/datasource/word_detail_remote_data_source.dart';

/// Repository implementations
export 'data/repository/word_detail_repository_impl.dart';

// Presentation Layer
/// ViewModels for state management
export 'presentation/viewmodel/word_detail_view_model.dart'; 