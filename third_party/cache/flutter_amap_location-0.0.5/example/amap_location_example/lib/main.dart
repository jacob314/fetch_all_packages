import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_amap_location/flutter_amap_location.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter AMap location example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _longitude = 0.0;
  double _latitude = 0.0;
  String _address = "未知地址";

  Future<void> getLocationOnce() async {
    String address;
    try {
      await FlutterAmapLocation.getLocationOnce();
    } on PlatformException catch (e) {
      address = "Failed to get address: '${e.message}'";
    }

    setState(() {
      _longitude = 0.0;
      _latitude = 0.0;
      _address = address;
    });
  }

  Future<void> stopLocation() async {
    try {
      await FlutterAmapLocation.stopLocation();
    } on PlatformException catch (e) {
       print( "Failed to stop location: '${e.message}'");
    }
  }

  void _onLocation(Object event) {
    Map<String, Object> loc = Map.castFrom(event);

    setState(() {
      _longitude = loc['longitude'];
      _latitude = loc['latitude'];
      _address = loc['address'];
    });
  }

  void _onError(Object event) {
    /*
    Map<String, Object> loc = Map.castFrom(event);

    setState(() {
      _longitude = 0.0;
      _latitude = 0.0;
      _address = loc['errorinfo'];
    });
    */
    print(event);
  }

  @override
  Widget build(BuildContext context) {
    FlutterAmapLocation.listenLocation(_onLocation, _onError);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("经度：$_longitude"),
            new Text("纬度：$_latitude"),
            new Text("地址: $_address"),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(onPressed: getLocationOnce, child: new Text("定位")),
                new RaisedButton(onPressed: stopLocation, child: new Text("停止定位")),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
