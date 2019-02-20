import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:simple_step_history/simple_step_history.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data = List<String>();
  var stepAvailable = false;

  @override
  void initState() {
    super.initState();
    // initStepsAvailability();
    requestSteps();
  }

  Future<void> requestSteps() async {
    final granted = await SimpleStepHistory.requestAuthorization();
    setState(() => stepAvailable = granted);
  }

  Future<void> initStepsAvailability() async {
    final available = await SimpleStepHistory.isStepsAvailable;
    setState(() => stepAvailable = available);
  }

  Future<void> getWeekSteps() async {
    data = [];
    final fmt = DateFormat('yyyy-MM-dd');
    for (var i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final str = fmt.format(date);
      final steps = await SimpleStepHistory.getStepsForDay(dateStr: str);
      data.add('DATE: $str - COUNT: ${steps < 0 ? 'N/A' : '$steps'}');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () => getWeekSteps(),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Text('IsStepAvailable : ${stepAvailable ? true : false}'),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, idx) {
                    return ListTile(title: Text(data[idx]));
                  },
                ),
              ),
            ],
          )),
    );
  }
}
