class DateTimeUtils {
  static String _zeroPadding(int val, {int width = 2}) {
    return '$val'.padLeft(width, '0');
  }

  static String buildDateTime(DateTime dateTime) {
    return '${toTimeString(dateTime)} ${_zeroPadding(dateTime.day)}/${_zeroPadding(dateTime.month)}/${dateTime.year}';
  }

  static String toTimeString(DateTime dateTime) {
    return '${_zeroPadding(dateTime.hour)}:${_zeroPadding(dateTime.minute)}';
  }
}