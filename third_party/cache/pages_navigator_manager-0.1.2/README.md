# Pages Navigator Manager
Wraps a navigator and a widget, providing a easy way to separate a navigator from root navigator

## Usage
To use this plugin, add `pages_navigator_manager` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
import 'package:flutter/material.dart';
import 'package:pages_navigator_manager/pages_navigator_manager.dart';

void main() => runApp(MaterialApp(
      home: Demo(),
    ));

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page1'),),
      body: Container(
        color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PagesNavigatorManager(rootPage: Page2_1());
        }));
      }),
    );
  }
}

class Page2_1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page2-1'),),

      body: Container(
        color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Page2_2();
        }));
      }),
    );
  }
}
class Page2_2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageNavigator pageNavigator = PageNavigator.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Page2-2'),),
      body: Container(
        color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
          pageNavigator.dismissPageNavigator(null);
      }),
    );
  }
}
```