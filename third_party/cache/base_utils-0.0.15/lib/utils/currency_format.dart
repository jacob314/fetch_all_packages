
import 'package:base_utils/utils/logging_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String currencyFormat(int money) {
  if(money == null){
    return "";
  }
  String moneyStr = money.toString();
  String finalStr = "";
  int groupSize = 3;
  int oddNumberLength = moneyStr.length - (moneyStr.length~/groupSize)*groupSize;
  if(oddNumberLength > 0){
    finalStr += moneyStr.substring(0, oddNumberLength);
    if(moneyStr.length > groupSize){
      finalStr += ".";
    }
  }
  for(int i = oddNumberLength; i< moneyStr.length; i+= groupSize){
    finalStr += moneyStr.substring(i, i + groupSize);
    if(i+groupSize < moneyStr.length - 1){
      finalStr += ".";
    }
  }
  return finalStr;
}

class CurrencyFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      log(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = new NumberFormat("###,###");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}