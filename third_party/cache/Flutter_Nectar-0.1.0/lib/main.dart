import 'package:flutter/material.dart';

import 'package:solido_nectar/solido.nectar.dart';

void main() {
  runApp(new SolidoApp());
}

class SolidoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Solido Nectar',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SolidoNectarPage(title: 'Solido Nectar Image'),
    );
  }
}

class SolidoNectarPage extends StatefulWidget {
  SolidoNectarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SolidoNectarPageState createState() => new _SolidoNectarPageState();
}

class _SolidoNectarPageState extends State<SolidoNectarPage> {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new NectarImage.loadingScreen(
        'https://camo.githubusercontent.com/cc78649bf43a7295cbab36eb7b5c7fe05b0f2bdb/68747470733a2f2f666c75747465722e696f2f696d616765732f666c75747465722d6d61726b2d7371756172652d3130302e706e67',
        duration: 4000,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        /*waiting: new Icon(
            Icons.person,
            size: 18.0,
            color: Colors.red
        )*/
      ),
    );
  }
}
