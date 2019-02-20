import 'package:flutter/material.dart';
import 'package:custom_loader/custom.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Loader',
      home: MyHomePage(title: 'Custom loader'),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: CustomLoader(
            coveredPercent: 75,
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
      ),
    );
  }
}
