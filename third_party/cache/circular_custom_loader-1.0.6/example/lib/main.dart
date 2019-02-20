import 'package:flutter/material.dart';
import 'package:circular_custom_loader/circular_custom_loader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Custom Loader',
      home: MyHomePage(title: 'Circular Custom Loader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CircularLoader(
          coveredPercent: 55,
          width: 150.0,
          height: 150.0,
          circleWidth: 12.0,
          circleColor: Colors.grey[300],
          coveredCircleColor: Colors.green,
          circleHeader: 'Progress..',
          unit: '%',
          coveredPercentStyle: Theme.of(context).textTheme.title.copyWith(
              fontSize: 44.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: Colors.black87),
          circleHeaderStyle: Theme.of(context).textTheme.title.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
        ),
      ),
    );
  }
}
