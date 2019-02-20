library trmsta.download;

import 'package:flutter/http.dart' as http;
import 'dart:async';
import 'dtype.dart';

const THE_URL = "http://trm24.pl/panel-trm/maps.jsp";

Future<String> downloadString([String url = THE_URL]) async {
  return await http.read(url);
}

Future<Downloaded> download([String url = THE_URL]) async {
  DateTime time = new DateTime.now();
  return new Downloaded(await downloadString(url), time);
}
