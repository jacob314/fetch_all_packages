import 'package:test/test.dart';
import 'package:flutter/services.dart';

import 'package:currency_input_formatter/currency_input_formatter.dart';

void main() {
  test('disallows non-digit values', () {
    final currencyFormatter = new CurrencyInputFormatter();
    final oldValue = const TextEditingValue();
    final newValue = const TextEditingValue(text: "A");
    final expectedValue = oldValue;

    expect(currencyFormatter.formatEditUpdate(oldValue, newValue), equals(expectedValue));
  });

  test('disallows more than one period', () {
    final currencyFormatter = new CurrencyInputFormatter();
    final oldValue = const TextEditingValue(text: "25.2");
    final newValue = const TextEditingValue(text: "25.2.");
    final expectedValue = oldValue;

    expect(currencyFormatter.formatEditUpdate(oldValue, newValue), equals(expectedValue));
  });

  test('does not allow periods when they are turned off', () {
    final currencyFormatter = new CurrencyInputFormatter(allowSubdivisions: false);
    final oldValue = const TextEditingValue(text: "25");
    final newValue = const TextEditingValue(text: "25.");
    final expectedValue = oldValue;

    expect(currencyFormatter.formatEditUpdate(oldValue, newValue), equals(expectedValue));
  });

  test('can change the subdivision marker, and disallow if it told', () {
    final currencyFormatter = new CurrencyInputFormatter(allowSubdivisions: false, subdivisionMarker: ",");
    final oldValue = const TextEditingValue(text: "25");
    final newValue = const TextEditingValue(text: "25,");
    final expectedValue = oldValue;

    expect(currencyFormatter.formatEditUpdate(oldValue, newValue), equals(expectedValue));
  });

  test('can change the subdivision marker, and disallow repitions of it', () {
    final currencyFormatter = new CurrencyInputFormatter(subdivisionMarker: ",");
    final oldValue = const TextEditingValue(text: "25,2");
    final newValue = const TextEditingValue(text: "25,2,");
    final expectedValue = oldValue;

    expect(currencyFormatter.formatEditUpdate(oldValue, newValue), equals(expectedValue));
  });
}