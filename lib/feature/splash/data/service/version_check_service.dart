import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheckService {
  /// Mevcut uygulama versiyonunu al
  Future<String> getCurrentAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      // Hata durumunda varsayılan değer döndür
      return '1.0.0';
    }
  }

  /// Platform'a göre versiyon kontrolü yap
  bool isUpdateRequired({
    required String currentVersion,
    required String requiredVersion,
  }) {
    return _compareVersions(currentVersion, requiredVersion) < 0;
  }

  /// Versiyon karşılaştırma metodu
  int _compareVersions(String version1, String version2) {
    List<int> v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Eksik kısımları 0 ile doldur
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }

  /// Platform'a göre gerekli versiyonu al
  String getRequiredVersionForPlatform({
    required String androidVersion,
    required String iosVersion,
  }) {
    if (Platform.isAndroid) {
      return androidVersion;
    } else if (Platform.isIOS) {
      return iosVersion;
    }
    return androidVersion; // Varsayılan olarak Android
  }
} 