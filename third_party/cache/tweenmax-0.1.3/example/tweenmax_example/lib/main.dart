import 'package:flutter/material.dart';
import 'package:flutter_example/screens/basic_example.dart';
import 'package:flutter_example/screens/animated_column_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeScreen(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => HomeScreen(),
        '/basic_example' : (BuildContext context) => BasicExample(),
        '/animated_column_chart' : (BuildContext context) => AnimatedColumnChart(),
      }
    );
  } 
}

class ExampleItem {
  final String title;
  final String route;

  ExampleItem(this.title, this.route);
}

class HomeScreen extends StatelessWidget {

  final List<ExampleItem> examples = [
    ExampleItem("Basic Example", "/basic_example"),
    ExampleItem("Animated Column Chart", "/animated_column_chart"),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("TweenMax Examples"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: examples.length,
          itemBuilder: (context, index){
            return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]))
              ),
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                // color: Colors.red,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${(index + 1)}. ${examples[index].title}",
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      )
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
                
                onPressed: (){
                  Navigator.of(context).pushNamed(examples[index].route);
                },
              ),
            );
          },
        ),
      ),
    );
    
  }
}
