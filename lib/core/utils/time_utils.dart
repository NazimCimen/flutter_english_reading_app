class TimeUtils {
  static String timeAgoSinceDate(DateTime? articleDate) {
    if (articleDate == null) {
      return '';
    }
    final dateNow = DateTime.now();
    final difference = dateNow.difference(articleDate);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years yıl önce';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks hafta önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inSeconds > 30) {
      return '${difference.inSeconds} saniye önce';
    } else {
      return 'Şimdi';
    }
  }
}
