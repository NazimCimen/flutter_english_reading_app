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