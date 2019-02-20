import 'dart:math';

double roundToPrecision2(double num) {
  return roundToPrecision(2, num);
}

double roundToPrecision1(double num) {
  return roundToPrecision(1, num);
}

double roundToPrecision(int decimals, double num) {
  if (decimals == null || decimals < 1) decimals = 1;
  int fac = pow(10, decimals);
  return (num * fac).round() / fac;
}

bool isNumValid(dynamic num){
  return num is int;
}