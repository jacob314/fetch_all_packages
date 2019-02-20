import 'dart:convert';

import 'package:base_utils/utils/logging_utils.dart';
import 'package:intl/intl.dart';

String capitalize(String s) {
  var tmp = s;
  if (isNotEmpty(tmp)) {
    tmp = tmp.substring(0, 1).toUpperCase() +
        (tmp.length > 1 ? tmp.substring(1) : "");
  }
  return tmp;
}

int safeParseToInt(dynamic num) {
  if (num is int) {
    return num;
  } else {
    return int.parse(num);
  }
}

bool isNotEmpty(String s) {
  return s != null && s.trim().length > 0;
}

bool isEmpty(String s) {
  return !isNotEmpty(s);
}

String convertToFirebaseText(String origin) {
  String tmp = origin;
  if (isEmpty(tmp)) {
    tmp = '';
  } else {
    tmp = tmp.replaceAll(
        new RegExp(r'[~,!,@,#,$,%,^,&,*,(,),=,+,|,.,/,<,>,?,-]'), '_');
    if (tmp.length > 20) {
      tmp = tmp.substring(0, 10) + tmp.substring(tmp.length - 10);
    }
  }
  return tmp;
}

final CURRENCY_FORMAT = new NumberFormat("#,##0", "vi_VN");

String formatCurrency(double m) {
  return CURRENCY_FORMAT.format(m);
}

String formatCurrencyD(double m) {
  return CURRENCY_FORMAT.format(m) + "đ";
}

dynamic convertToMap(dynamic tmp) {
  try {
    return json.decode(json.encode(tmp));
  } catch (e) {
    log(e);
    return null;
  }
}

Map<String, dynamic> parseRoute(String route) {
  log('parseRoute: $route');
  if (route == null) return null;

  String routeName = '', jsonData;
  if (route.contains('/')) {
    routeName = route.substring(0, route.indexOf("/"));
    jsonData = route.substring(route.indexOf("/") + 1);
  } else {
    routeName = route;
  }
  Map<String, dynamic> data =
      jsonData != null ? json.decode("$jsonData") : null;

  log('parseRoute: data=$data');

  return {'routeName': routeName, 'data': data};
}
