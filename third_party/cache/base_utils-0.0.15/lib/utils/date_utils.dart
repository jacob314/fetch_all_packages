import 'package:base_utils/utils/number_utils.dart';
import 'package:intl/intl.dart';

String parseMillisToSecond(int millis) {
  if (millis == null) {
    return "0";
  }

  return (roundToPrecision1(millis / 1000)).toString() + "s";
}

String parseMillisToHms(Duration d) {
  var numberHours, numberMin, numberSenc;

  numberHours = d.inHours % 24;
  numberMin = d.inMinutes % 60;
  numberSenc = d.inSeconds % 60;

  return "${numberHours.toString().padLeft(2, '0')}:${numberMin.toString().padLeft(2, '0')}:${numberSenc.toString().padLeft(2, '0')}";
}

String parseMillisToDayMonth(
  int millis, {
  String pattern = "dd/MM",
  bool isUTC = false,
}) {
  if (millis == null) {
    return "";
  }
  final time = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: isUTC);

  final f = DateFormat(pattern);
  return f.format(time);
}

int parseDateToMillis(String date) {
  if (date == null) {
    return 0;
  }
  final f = DateFormat("yyyy-MM-dd");
  return f.parse(date, true).millisecondsSinceEpoch;
}

DateTime parse(String pattern, String date) {
  var format = DateFormat(pattern);
  return format.parse(date);
}
