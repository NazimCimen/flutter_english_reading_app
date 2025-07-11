# English Reading App 📚

A modern English reading and vocabulary learning application developed with Flutter. Users can read articles, learn word meanings, create personal word banks, and save favorite articles.

## 🚀 Features

### 📖 Article Reading
- **Article List**: Articles filtered by categories
- **Detailed Reading**: Full-screen article reading experience
- **Word Clicking**: Learn meanings by clicking on words in articles
- **Add to Favorites**: Save liked articles

### 🔤 Word Bank
- **Personal Word Collection**: Save learned words
- **Word Details**: Meanings, example sentences, and pronunciation
- **Manual Word Addition**: Add new words feature
- **Word Search**: Search within word bank

### 👤 User Management
- **Firebase Authentication**: Login with Google and email/password
- **Email Verification**: Email verification system for security
- **Profile Management**: Update user information
- **Theme Management**: Light/dark theme support

### 🌐 Multi-language Support
- **Turkish/English**: Language selection for app interface
- **Dynamic Translation**: Translation system with easy_localization

### 🧪 Testing & Quality Assurance
- **Unit Tests**: Comprehensive test coverage for all layers
- **Repository Tests**: Data layer testing with mock implementations
- **UseCase Tests**: Domain layer testing with clean architecture
- **ViewModel Tests**: Presentation layer testing
- **CI/CD Pipeline**: Automated testing with GitHub Actions
- **Test Automation**: Automatic test execution on every commit

## 🏗️ Technical Architecture

### Clean Architecture
The project is structured according to Clean Architecture principles:

```
lib/
├── core/                    # Core infrastructure and helper classes
├── config/                  # Application configuration
├── product/                 # Shared components and models
├── feature/                 # Feature-based modules
└── services/               # Global services
```

### Layer Structure

#### 1. **Core Layer** (`/core`)
- **Size Management**: Size management for responsive design
- **Error Handling**: Exception and Failure management
- **Cache Management**: Local data storage
- **Network**: Internet connection control
- **Utils**: Helper functions and validations

#### 2. **Config Layer** (`/config`)
- **Localization**: Multi-language support
- **Routes**: Navigation management
- **Theme**: Theme and color management

#### 3. **Product Layer** (`/product`)
- **Models**: Data models (Article, User, Dictionary, etc.)
- **Components**: Shared UI components
- **Constants**: Constant values and colors
- **Firebase**: Firebase integration

#### 4. **Feature Layer** (`/feature`)
Each feature is organized in its own folder:
- **Data Layer**: Repository, DataSource, Service
- **Presentation Layer**: View, ViewModel, Widget, Mixin

## 🛠️ Technologies Used

### Framework & Language
- **Flutter**: 3.x
- **Dart**: 3.x

### State Management
- **Provider**: For state management
- **ChangeNotifier**: ViewModel pattern

### Backend & Database
- **Firebase Auth**: User authentication
- **Cloud Firestore**: NoSQL database
- **Firebase Storage**: File storage
- **Firebase Options**: Generated configuration for Firebase services

### HTTP & API
- **Dio**: HTTP requests
- **Pretty Dio Logger**: API logging

### Local Storage
- **Shared Preferences**: Simple data storage
- **Flutter Secure Storage**: Secure data storage
- **Hive**: Local database

### UI & Design
- **Material Design 3**: Modern UI design
- **Google Fonts**: Custom fonts
- **Flutter SVG**: SVG support
- **Shimmer**: Loading animations

### Localization
- **Easy Localization**: Multi-language support
- **Intl**: Date and number formatting

### Testing
- **Mockito**: Mocking framework for unit tests
- **Build Runner**: Code generation for mocks
- **Test Coverage**: Comprehensive test coverage

### Utilities
- **Dartz**: Functional programming (Either, Option)
- **Get It**: Dependency injection
- **Connectivity Plus**: Internet connection control
- **URL Launcher**: External link opening
- **Share Plus**: Content sharing

### CI/CD & DevOps
- **GitHub Actions**: Automated CI/CD pipeline
- **Secret Management**: Secure environment variable handling
- **Automated Testing**: Continuous integration with test automation

## 📦 Project Structure

### Feature Structure
```
feature/
├── auth/                   # Authentication
│   ├── login/
│   ├── sign_up/
│   ├── forget_password/
│   └── widgets/
├── home/                   # Home page
│   ├── presentation/
│   └── repository/
├── article_detail/         # Article detail
├── word_bank/             # Word bank
├── saved_articles/        # Saved articles
├── profile/               # Profile management
└── splash/                # Splash screen
```

### Core Structure
```
core/
├── size/                  # Size management
├── error/                 # Error handling
├── cache/                 # Cache management
├── connection/            # Network connection
├── utils/                 # Helper functions
└── app/                   # Application configuration
```

### Test Structure
```
test/
├── feature/               # Feature-specific tests
│   ├── saved_articles/    # Saved articles tests
│   └── word_detail/       # Word detail tests
│       ├── data/          # Data layer tests
│       │   ├── datasource/
│       │   └── repository/
│       ├── domain/        # Domain layer tests
│       │   └── usecase/
│       └── presentation/  # Presentation layer tests
│           └── viewmodel/
└── widget_test.dart       # Widget tests
```

## 🔄 Version History

### v1.1.0 (Current)
- ✅ Authentication system
- ✅ Article reading
- ✅ Word bank
- ✅ Saved articles
- ✅ Profile management
- ✅ Email verification
- ✅ Multi-language support
- ✅ **Unit Testing**: Comprehensive test coverage
- ✅ **CI/CD Pipeline**: GitHub Actions integration
- ✅ **Firebase Options**: Generated configuration
- ✅ **Test Automation**: Automated test execution

### v1.0.0
- ✅ Authentication system
- ✅ Article reading
- ✅ Word bank
- ✅ Saved articles
- ✅ Profile management
- ✅ Email verification
- ✅ Multi-language support

### Upcoming Features
- 🔜 Offline reading
- 🔜 Voice pronunciation
- 🔜 Reading statistics
- 🔜 Social features
- 🔜 Gamification elements

## 🧪 Testing

### Test Coverage
The project includes comprehensive unit tests covering:
- **Domain Layer**: UseCase tests with clean architecture
- **Data Layer**: Repository and DataSource tests
- **Presentation Layer**: ViewModel tests
- **Error Handling**: Exception and Failure tests

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/feature/word_detail/domain/usecase/get_word_detail_from_api_usecase_test.dart
```

### CI/CD Pipeline
- **Automated Testing**: Tests run automatically on every commit
- **GitHub Actions**: Custom CI workflow with secret management
- **Test Reports**: Detailed test results and coverage reports

---

**English Reading App** - A modern English reading application developed with Flutter that makes learning fun 📚✨