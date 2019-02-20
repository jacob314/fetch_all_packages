import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_loader/main.dart';

void main() {
  testWidgets('Hello there flutter tester', (WidgetTester tester) async {
    debugDumpApp();
    await tester.pumpWidget(MyApp());
  });
}
