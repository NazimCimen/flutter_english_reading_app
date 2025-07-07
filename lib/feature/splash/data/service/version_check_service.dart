import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheckService {
  /// Get current app version
  Future<String> getCurrentAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
          // Return default value in case of error
    return '1.0.0';
    }
  }

  /// Check version based on platform
  bool isUpdateRequired({
    required String currentVersion,
    required String requiredVersion,
  }) {
    return _compareVersions(currentVersion, requiredVersion) < 0;
  }

  /// Version comparison method
  int _compareVersions(String version1, String version2) {
    List<int> v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Fill missing parts with 0
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }

  /// Get required version based on platform
  String getRequiredVersionForPlatform({
    required String androidVersion,
    required String iosVersion,
  }) {
    if (Platform.isAndroid) {
      return androidVersion;
    } else if (Platform.isIOS) {
      return iosVersion;
    }
    return androidVersion; // Default to Android
  }
} 