import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:gscarousel/gscarousel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GSCarousel'),
          elevation: 0.2,
          backgroundColor: Colors.green,
          brightness: Brightness.light,
        ),
        body: new Container(
          child: new SizedBox(
            height: 140.0,
            child: new GSCarousel(
              images: [
                new NetworkImage(
                        'https://www.blibli.com/page/wp-content/uploads/Ulas-Puas-Banner-utama1.jpg'),
                    new NetworkImage(
                        'https://www.blibli.com/friends/assets/banner2.jpg'),
                    new NetworkImage(
                        'https://www.static-src.com/siva/asset//06_2017/microsite-banner--1200x460.jpg'),
                    new NetworkImage(
                        'https://www.static-src.com/siva/asset//03_2017/brandedbabytoy-toy-header.jpg'),
              ],
              indicatorSize: const Size.square(8.0),
              indicatorActiveSize: const Size(18.0, 8.0),
              indicatorColor: Colors.white,
              indicatorActiveColor: Colors.redAccent,
              animationCurve: Curves.easeIn,
              contentMode: BoxFit.cover,
              // indicatorBackgroundColor: Colors.greenAccent,
            ),
          ),
        ),
      ),
    );
  }
}
