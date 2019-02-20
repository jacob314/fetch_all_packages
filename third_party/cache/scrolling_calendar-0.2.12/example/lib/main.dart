import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrolling_calendar/scrolling_calendar.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static final Random random = new Random();

  static Iterable<Color> randomColors() => <Color>[]
    ..addAll(random.nextBool() ? <Color>[] : <Color>[Colors.red])
    ..addAll(random.nextBool() ? <Color>[] : <Color>[Colors.blue])
    ..addAll(random.nextBool() ? <Color>[] : <Color>[Colors.green]);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Scrolling calendar',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => new Scaffold(
            body: new ScrollingCalendar(
                firstDayOfWeek: DateTime.monday,
                onDateTapped: (DateTime date) => showDialog(
                    context: context,
                    builder: (BuildContext context) => new AlertDialog(
                          content: new Text("You tapped $date"),
                        )),
                selectedDate: new DateTime(2018, 2, 20),
                colorMarkers: (_) => randomColors()))
      },
    );
  }
}
