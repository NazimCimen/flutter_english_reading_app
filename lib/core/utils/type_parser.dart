class TypeParser {
  TypeParser._();

  static DateTime? parseDateTime(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static int? parseInt(String intString) {
    try {
      return int.parse(intString);
    } catch (e) {
      return null;
    }
  }

  static DateTime formatDateTime(DateTime dateTime) {
    final date = dateTime.toUtc();
    final year = date.year;
    final month = date.month;
    final day = date.day;

    return DateTime(year, month, day, 0, 0, 0, 0);
  }
}
