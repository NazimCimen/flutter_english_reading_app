# English Reading App 📚

Flutter ile geliştirilmiş modern bir İngilizce okuma ve kelime öğrenme uygulaması. Kullanıcılar makaleler okuyabilir, kelime anlamlarını öğrenebilir, kişisel kelime bankası oluşturabilir ve favorilere makale ekleyebilir.

## 🚀 Özellikler

### 📖 Makale Okuma
- **Makale Listesi**: Kategorilere göre filtrelenmiş makaleler
- **Detaylı Okuma**: Tam ekran makale okuma deneyimi
- **Kelime Tıklama**: Makaledeki kelimelere tıklayarak anlamlarını öğrenme
- **Favorilere Ekleme**: Beğenilen makaleleri kaydetme

### 🔤 Kelime Bankası
- **Kişisel Kelime Koleksiyonu**: Öğrenilen kelimeleri kaydetme
- **Kelime Detayları**: Anlam, örnek cümleler ve telaffuz
- **Manuel Kelime Ekleme**: Yeni kelimeler ekleme özelliği
- **Kelime Arama**: Kelime bankasında arama yapma

### 👤 Kullanıcı Yönetimi
- **Firebase Authentication**: Google ve email/password ile giriş
- **Email Doğrulama**: Güvenlik için email doğrulama sistemi
- **Profil Yönetimi**: Kullanıcı bilgilerini güncelleme
- **Tema Yönetimi**: Açık/koyu tema desteği

### 🌐 Çoklu Dil Desteği
- **Türkçe/İngilizce**: Uygulama arayüzü için dil seçimi
- **Dinamik Çeviri**: easy_localization ile çeviri sistemi

## 🏗️ Teknik Mimari

### Clean Architecture
Proje, Clean Architecture prensiplerine göre yapılandırılmıştır:

```
lib/
├── core/                    # Temel altyapı ve yardımcı sınıflar
├── config/                  # Uygulama yapılandırması
├── product/                 # Paylaşılan bileşenler ve modeller
├── feature/                 # Özellik bazlı modüller
└── services/               # Global servisler
```

### Katman Yapısı

#### 1. **Core Layer** (`/core`)
- **Size Management**: Responsive tasarım için boyut yönetimi
- **Error Handling**: Exception ve Failure yönetimi
- **Cache Management**: Yerel veri saklama
- **Network**: İnternet bağlantısı kontrolü
- **Utils**: Yardımcı fonksiyonlar ve validasyonlar

#### 2. **Config Layer** (`/config`)
- **Localization**: Çoklu dil desteği
- **Routes**: Navigasyon yönetimi
- **Theme**: Tema ve renk yönetimi

#### 3. **Product Layer** (`/product`)
- **Models**: Veri modelleri (Article, User, Dictionary vb.)
- **Components**: Paylaşılan UI bileşenleri
- **Constants**: Sabit değerler ve renkler
- **Firebase**: Firebase entegrasyonu

#### 4. **Feature Layer** (`/feature`)
Her özellik kendi klasöründe organize edilmiştir:
- **Data Layer**: Repository, DataSource, Service
- **Presentation Layer**: View, ViewModel, Widget, Mixin

## 🛠️ Kullanılan Teknolojiler

### Framework & Language
- **Flutter**: 3.x
- **Dart**: 3.x

### State Management
- **Provider**: State yönetimi için
- **ChangeNotifier**: ViewModel pattern

### Backend & Database
- **Firebase Auth**: Kullanıcı kimlik doğrulama
- **Cloud Firestore**: NoSQL veritabanı
- **Firebase Storage**: Dosya depolama

### HTTP & API
- **Dio**: HTTP istekleri
- **Pretty Dio Logger**: API log'ları

### Local Storage
- **Shared Preferences**: Basit veri saklama
- **Flutter Secure Storage**: Güvenli veri saklama
- **Hive**: Yerel veritabanı

### UI & Design
- **Material Design 3**: Modern UI tasarımı
- **Google Fonts**: Özel fontlar
- **Flutter SVG**: SVG desteği
- **Shimmer**: Loading animasyonları

### Localization
- **Easy Localization**: Çoklu dil desteği
- **Intl**: Tarih ve sayı formatlama

### Utilities
- **Dartz**: Functional programming (Either, Option)
- **Get It**: Dependency injection
- **Connectivity Plus**: İnternet bağlantısı kontrolü
- **URL Launcher**: Harici link açma
- **Share Plus**: İçerik paylaşımı

## 📱 Özellik Detayları

### Authentication System
```dart
// Firebase Auth ile Google Sign-in
Future<Either<Failure, bool>> signInWithGoogle();

// Email/Password ile giriş
Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
  String email, 
  String password
);

// Email doğrulama
Future<Either<Failure, bool>> sendEmailVerification();
```

### Article Reading System
- **Span Builder**: Metindeki kelimeleri tıklanabilir hale getirme
- **Word Detection**: Kelime tanıma ve sözlük entegrasyonu
- **Reading Progress**: Okuma ilerlemesi takibi

### Word Bank System
```dart
// Kelime kaydetme
Future<Either<Failure, bool>> saveWord(DictionaryEntry word);

// Kelime listesi getirme
Future<Either<Failure, List<DictionaryEntry>>> getUserWords();

// Kelime arama
Future<Either<Failure, DictionaryEntry>> searchWord(String word);
```

### Cache Management
```dart
// Güvenli cache (şifrelenmiş)
class EncryptedCacheManager extends BaseCacheManager<String>

// Standart cache
class StandartCacheManager extends BaseCacheManager<String>
```

## 🎨 UI/UX Design System

### Size Management
```dart
// Constant sizes
context.cLowValue        // 8.0
context.cMediumValue     // 16.0
context.cLargeValue      // 24.0

// Dynamic sizes (responsive)
context.dLowValue        // dynamicHeight(0.01)
context.dMediumValue     // dynamicHeight(0.02)
context.dynamicWidth(0.8) // Ekranın %80'i
```

### Padding System
```dart
// All directions
context.paddingAllLow
context.paddingAllMedium
context.paddingAllLarge

// Horizontal/Vertical
context.paddingHorizAllMedium
context.paddingVertAllLarge
```

### Border Radius
```dart
// All corners
context.borderRadiusAllMedium
context.cBorderRadiusAllLarge

// Directional
context.borderRadiusTopMedium
context.borderRadiusBottomLarge
```

### Color System
```dart
// Fixed colors (same in dark/light)
AppColors.primaryColor
AppColors.secondaryColor

// Dynamic colors (different in dark/light)
context.colorScheme.primary
context.colorScheme.surface
```

## 🔧 Error Handling

### Exception Types
```dart
// Service layer exceptions
ServerException('Server connection failed')
CacheException('Cache read failed')
ConnectionException('No internet connection')
UnKnownException('Unknown error occurred')
```

### Failure Types
```dart
// Repository layer failures
ServerFailure(errorMessage: 'Server error')
CacheFailure(errorMessage: 'Cache error')
ConnectionFailure(errorMessage: 'Network error')
```

### Either Pattern
```dart
// All service operations return Either<Failure, T>
Future<Either<Failure, UserModel>> getUser();
Future<Either<Failure, List<ArticleModel>>> getArticles();
Future<Either<Failure, bool>> saveWord(DictionaryEntry word);
```

## 📦 Proje Yapısı

### Feature Structure
```
feature/
├── auth/                   # Kimlik doğrulama
│   ├── login/
│   ├── sign_up/
│   ├── forget_password/
│   └── widgets/
├── home/                   # Ana sayfa
│   ├── presentation/
│   └── repository/
├── article_detail/         # Makale detayı
├── word_bank/             # Kelime bankası
├── saved_articles/        # Kaydedilen makaleler
├── profile/               # Profil yönetimi
└── splash/                # Başlangıç ekranı
```

### Core Structure
```
core/
├── size/                  # Boyut yönetimi
├── error/                 # Hata yönetimi
├── cache/                 # Cache yönetimi
├── connection/            # Ağ bağlantısı
├── utils/                 # Yardımcı fonksiyonlar
└── app/                   # Uygulama yapılandırması
```

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK (3.x+)
- Dart SDK (3.x+)
- Android Studio / VS Code
- Firebase projesi

### Kurulum Adımları

1. **Projeyi klonlayın**
```bash
git clone https://github.com/your-repo/english_reading_app.git
cd english_reading_app
```

2. **Bağımlılıkları yükleyin**
```bash
flutter pub get
```

3. **Firebase yapılandırması**
```bash
# Firebase CLI kurulumu
npm install -g firebase-tools

# Firebase'e giriş
firebase login

# FlutterFire CLI kurulumu
dart pub global activate flutterfire_cli

# Firebase yapılandırması
flutterfire configure
```

4. **JSON Serialization**
```bash
flutter packages pub run build_runner build
```

5. **Uygulamayı çalıştırın**
```bash
flutter run
```

### Build Commands
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🧪 Testing

### Test Yapısı
```
test/
├── unit/                  # Unit testler
├── widget/                # Widget testler
└── integration/           # Entegrasyon testler
```

### Test Komutları
```bash
# Tüm testleri çalıştır
flutter test

# Coverage raporu
flutter test --coverage
```

## 📊 Performance Optimizations

### Image Optimization
- **Cached Network Image**: Resim cache'leme
- **Image Compression**: Otomatik sıkıştırma
- **Lazy Loading**: Gerektiğinde yükleme

### Memory Management
- **Dispose Pattern**: ViewModel'lerde proper dispose
- **Stream Subscription**: Memory leak önleme
- **Cache Size Limits**: Cache boyut sınırları

### Network Optimization
- **Request Caching**: API yanıt cache'leme
- **Retry Logic**: Başarısız istekleri yeniden deneme
- **Connection Pooling**: Bağlantı havuzu yönetimi

## 🔐 Security

### Data Protection
- **Encrypted Storage**: Hassas veriler için şifreleme
- **Firebase Security Rules**: Veritabanı güvenlik kuralları
- **Input Validation**: Giriş verisi doğrulama

### Authentication Security
- **Email Verification**: Email doğrulama zorunluluğu
- **Secure Token Storage**: Token'ları güvenli saklama
- **Session Management**: Oturum yönetimi

## 📈 Analytics & Monitoring

### Firebase Analytics
- **User Engagement**: Kullanıcı etkileşimi takibi
- **Screen Tracking**: Sayfa görüntüleme istatistikleri
- **Custom Events**: Özel olay takibi

### Crashlytics
- **Crash Reporting**: Uygulama çökme raporları
- **Error Tracking**: Hata takibi ve analizi
- **Performance Monitoring**: Performans izleme

## 🤝 Contributing

### Code Style
- **Dart Conventions**: Dart kodlama standartları
- **Naming Conventions**: Tutarlı isimlendirme
- **Comment Standards**: Yorum yazma kuralları

### Git Workflow
```bash
# Feature branch oluştur
git checkout -b feature/new-feature

# Değişiklikleri commit et
git commit -m "feat: add new feature"

# Pull request oluştur
git push origin feature/new-feature
```

### Code Review Checklist
- [ ] Clean Architecture prensiplerine uygunluk
- [ ] Error handling implementasyonu
- [ ] UI/UX design system kullanımı
- [ ] Test coverage
- [ ] Documentation

## 📄 License

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakınız.

## 👥 Team

- **Developer**: [Your Name]
- **UI/UX Designer**: [Designer Name]
- **Project Manager**: [PM Name]

## 📞 İletişim

- **Email**: your-email@example.com
- **GitHub**: [Your GitHub Profile]
- **LinkedIn**: [Your LinkedIn Profile]

---

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

**English Reading App** - Modern Flutter ile geliştirilmiş, öğrenmeyi eğlenceli hale getiren İngilizce okuma uygulaması 📚✨