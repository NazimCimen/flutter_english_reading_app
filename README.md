# English Reading App 📚 *(currently in development)*

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

### Utilities
- **Dartz**: Functional programming (Either, Option)
- **Get It**: Dependency injection
- **Connectivity Plus**: Internet connection control
- **URL Launcher**: External link opening
- **Share Plus**: Content sharing



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


## 🔄 Version History

### v1.0.0 (Current)
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

---

**English Reading App** - A modern English reading application developed with Flutter that makes learning fun 📚✨
