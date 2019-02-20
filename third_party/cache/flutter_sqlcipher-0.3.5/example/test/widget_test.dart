/* This is free and unencumbered software released into the public domain. */

// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_sqlcipher_example/main.dart';

////////////////////////////////////////////////////////////////////////////////

void main() {
  testWidgets("Verify SQLCipher version", (final WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate(
        (final Widget widget) =>
          widget is Text && widget.data.startsWith("Running on:"),
      ),
      findsOneWidget);
  });
}
