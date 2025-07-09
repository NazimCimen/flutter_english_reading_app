import 'package:url_launcher/url_launcher.dart';

abstract class UrlService {
  Future<bool> launchEmail(String email, String query);
  Future<bool> launchPrivacyPolicy();
  Future<bool> launchTermsConditions();
}

class UrlServiceImpl implements UrlService {
  @override
  Future<bool> launchEmail(String email, String query) async {
    final emailUrl = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull(query),
    );
    final result = await _launchUrl(emailUrl, 'E-posta URL açılamadı: $email');
    return result;
  }

  @override
  Future<bool> launchPrivacyPolicy() async {
    final url = Uri.parse(
      'https://www.nazimcimen.com/privacy_policy_lingzy.html',
    );
    return await _launchUrl(url, 'Gizlilik politikası linki açılamadı');
  }

  @override
  Future<bool> launchTermsConditions() async {
    final url = Uri.parse(
      'https://www.nazimcimen.com/terms_conditions_lingzy.html',
    );
    return await _launchUrl(url, 'Kullanım şartları linki açılamadı');
  }

  Future<bool> _launchUrl(Uri url, String errorMessage) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
