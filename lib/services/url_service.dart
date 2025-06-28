import 'package:url_launcher/url_launcher.dart';

abstract class UrlService {
  Future<bool> launchEmail(String email, String query);
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
