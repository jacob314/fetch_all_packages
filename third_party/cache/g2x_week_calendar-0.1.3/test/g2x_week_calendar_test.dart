import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g2x_week_calendar/util.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';

void main() {
  test("Get first day of week", (){
    expect(MyDateTime.getFirstDateOfWeek(new DateTime(2018, 12,12)), new DateTime(2018,12,9));
    expect(MyDateTime.getFirstDateOfWeek(new DateTime(2018, 12,16)), new DateTime(2018,12,16));
    expect(() => MyDateTime.getFirstDateOfWeek(null), throwsNoSuchMethodError);
  });

  test("Get week days", (){
    expect(MyDateTime.getDaysOfWeek(new DateTime(2018, 12,12)), [9,10,11,12,13,14,15]);
    expect(() => MyDateTime.getDaysOfWeek(null), throwsNoSuchMethodError);
  });

  test("Format date", (){
    expect(MyDateTime.formatDate(new DateTime(2018, 12,12)), "12/12/2018");
    expect(MyDateTime.formatDate(new DateTime(2018, 12,12), format: "yyyy/MM/dd"), "2018/12/12");
    expect(() => MyDateTime.formatDate(null, format: ""), throwsNoSuchMethodError);
    expect(() => MyDateTime.formatDate(null), throwsNoSuchMethodError);
  });

  //widget
  testWidgets("simpleWeekCalendar", (WidgetTester t) async {
    await t.pumpWidget(new MaterialApp(home: new Scaffold(body: G2xSimpleWeekCalendar(DateTime.now()))));
  });
  testWidgets("simpleWeekCalendar callback date", (WidgetTester t) async {
    DateTime date;
    DateTime dateTimeNow = DateTime.now();
    await t.pumpWidget(new MaterialApp(
      home: new Scaffold(body: G2xSimpleWeekCalendar(dateTimeNow, dateCallback: (val)=> date = val))));
    expect(date, dateTimeNow);
  });
}