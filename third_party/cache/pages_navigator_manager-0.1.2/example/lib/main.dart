import 'package:flutter/material.dart';
import 'package:pages_navigator_manager/pages_navigator_manager.dart';

void main() => runApp(MaterialApp(
      home: TabBarDemo(),
    ));



class CollectPersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChooseCredentialsPage();
        }));
      }),
      appBar: AppBar(
        title: Text('CollectPersonalInfoPage'),
      ),
    );
  }
}

class ChooseCredentialsPage extends StatelessWidget {
  final VoidCallback onSignupComplete;

  ChooseCredentialsPage({this.onSignupComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Page4();
        }));
      }),
      appBar: AppBar(
        title: Text('ChooseCredentialsPage'),
      ),
      body: SingleChildScrollView(
        child: Row(children: <Widget>[
          Offstage(
            offstage: true,
            child: Container(
              width: 200.0,
              height: 200.0,
              color: Colors.green,
            ),
          ),
          Offstage(
            offstage: false,
            child: Container(
              width: 200.0,
              height: 200.0,
              color: Colors.red,
            ),
          ),
        ]),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageNavigator bloc = PageNavigator.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.popUntil(context, (r) => r.isFirst);
//        bloc.dismiss(null);
      }),
      appBar: AppBar(
        title: Text('Page4'),
      ),
    );
  }
}

class TabBarDemo extends StatefulWidget {
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  int tabIdx = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> pages = [Page1(),Page2(),Page3()];

    return Scaffold(
      appBar: AppBar(
        title: Text('TabBarDemo'),
      ),
      body: PagesNavigatorManager(rootPage: pages[tabIdx]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabIdx,
          onTap: (int idx) {
            setState(() {
              tabIdx = idx;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.accessibility_new), title: Text('page1')),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm), title: Text('page2')),
            BottomNavigationBarItem(
                icon: Icon(Icons.pages), title: Text('page3')),
          ]),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CollectPersonalInfoPage();
        }));
      }),
    );
  }
}


class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CollectPersonalInfoPage();
        }));
      }),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CollectPersonalInfoPage();
        }));
      }),
    );
  }
}

