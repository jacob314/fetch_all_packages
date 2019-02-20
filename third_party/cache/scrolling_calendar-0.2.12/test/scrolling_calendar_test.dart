import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolling_calendar/calendar_month.dart';
import 'package:scrolling_calendar/scrolling_calendar.dart';

void main() {
  testWidgets('Construction in a material app succeeds',
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new ScrollingCalendar(),
      ),
    ));
  });
  testWidgets('The selected month is displayed initially',
      (WidgetTester tester) async {
    final DateTime startDate = new DateTime(2020, 2, 20);

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new ScrollingCalendar(
          selectedDate: startDate,
        ),
      ),
    ));

    expect(find.text(CalendarMonth.formatTitle(startDate)), findsOneWidget);
  });
}
