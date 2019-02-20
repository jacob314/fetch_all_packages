import 'dart:convert';

import 'package:base_utils/utils/logging_utils.dart';

String encode(String data) {
  //var bytes = Utf8Encoder().convert(data);
  String newdata = Base64Encoder().convert(data.codeUnits);

  int len = newdata.length;
  int i = 0;
  String left = "", right, center;
  while (i + 1 < len) {
    if (i > 0) {
      left = newdata.substring(0, i);
    }
    right = newdata.substring(i + 2);
    center = newdata.substring(i, i + 2);
    center = "${center[1]}${center[0]}";
    newdata = left + center + right;
    i += 2;
  }
  log('~~> encoded: ${newdata}');
//   Log.debug(TAG, "encoded: " + newdata);
  return newdata;
}

String decode(String data) {
  int len = data.length;
  int i = 0;
  String left = "", right, center;
  String newdata = data;
  while (i + 1 < len) {
    if (i > 0) {
      left = newdata.substring(0, i);
    }
    right = newdata.substring(i + 2);
    center = newdata.substring(i, i + 2);
    center = "${center[1]}${center[0]}";
    newdata = left + center + right;
    i += 2;
  }
  var decoded = Base64Decoder().convert(newdata);
  var bytes = Utf8Decoder().convert(decoded);

  // return String.fromCharCodes(decoded);
  return bytes;
}
