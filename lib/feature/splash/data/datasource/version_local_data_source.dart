import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/model/version_model.dart';

abstract class VersionLocalDataSource {
  Future<VersionModel> getCachedVersionInfo();
  Future<void> cacheVersionInfo(VersionModel versionModel);
}

class VersionLocalDataSourceImpl implements VersionLocalDataSource {
  // Gelecekte Hive veya SharedPreferences ile cache implementasyonu yapılabilir
  // Şimdilik boş bırakıyoruz

  @override
  Future<VersionModel> getCachedVersionInfo() async {
    throw CacheException('Cache henüz implement edilmedi');
  }

  @override
  Future<void> cacheVersionInfo(VersionModel versionModel) async {
    // Gelecekte cache implementasyonu
    throw CacheException('Cache henüz implement edilmedi');
  }
} 