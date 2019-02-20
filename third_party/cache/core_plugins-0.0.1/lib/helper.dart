import 'package:flutter/material.dart';

String formatNumer(int number) {
  final output = number > 9 ? number.toString() : "0${number}";

  return output;
}

 DateTime convertTimestampToDate(int timestamp) {
    
    final time = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return time;
  }

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

String serverTime = "";

