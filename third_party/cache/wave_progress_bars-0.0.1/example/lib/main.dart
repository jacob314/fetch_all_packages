import 'package:wave_progress_bars/wave_progress_bars.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(
      MaterialApp(
        title: 'Bars',
        theme: ThemeData(),
        home: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  final List<double> values = [];

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var rng = new Random();
    for (var i = 0; i < 100; i++) {
      values.add(rng.nextInt(70) * 1.0);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("bars"),
      ),
      body: Center(
        child: WaveProgressBar(
          progressPercentage: 20,
          listOfHeights: values,
          width: queryData.size.width,
          initalColor: Colors.grey,
          progressColor: Colors.red,
          backgroundColor: Colors.white,
          timeInMilliSeconds: 2000,
          isHorizontallyAnimated: true,
          isVerticallyAnimated: true,
        ),
      ),
    );
  }
}
