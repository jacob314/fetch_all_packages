import 'package:example/anatomy_screen.dart';
import 'package:example/catalog_screen.dart';
import 'package:example/demo_screen.dart';
import 'package:example/inspiration_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const Color trackColor = const Color(0xFFCCCCCC);
const Color seekColor = const Color(0xFFEEEEEE);
const Color progressColor = const Color(0xFF88AA66);
const Color thumbColor = const Color(0xFF44FF66);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttery Seekbar',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (_activeTabIndex) {
      case 0:
        screen = DemoPage();
        break;
      case 1:
        screen = InspirationPage();
        break;
      case 2:
        screen = AnatomyPage();
        break;
      case 3:
        screen = CatalogPage();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Fluttery Seekbar'),
      ),
      body: screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeTabIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_filled),
            title: Text('Demo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            title: Text('Inspiration'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            title: Text('Anatomy'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            title: Text('Catalog'),
          ),
        ],
        onTap: (int newIndex) {
          setState(() {
            _activeTabIndex = newIndex;
          });
        },
      ),
    );
  }
}
