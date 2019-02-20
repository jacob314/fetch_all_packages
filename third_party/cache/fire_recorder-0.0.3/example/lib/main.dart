import 'package:flutter/material.dart';
import 'package:fire_recorder/fire_recorder.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isRecording = false;


_startRecording() async {


      // _permis = await FireRecorder.hasPermissions;
        bool res = await SimplePermissions.requestPermission(Permission.RecordAudio);
        bool xres = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
        print("PERMISSIONS:" + res.toString() + " " +  xres.toString());
        // print("ISRECORDING:");
        var lol = await FireRecorder.isRecording();
        print("ISRECORDING: $lol");
        if (_isRecording) {
          print("STOPPING RECORDING");
          _isRecording = false ; //since we stop it now
          String recording = await FireRecorder.stop();
          print("Path : $recording");

          setState(() {
            _isRecording = false ;
          });
        } else {
          // print("permission request result is " + res.toString());
          print("STARTING RECORDING");
           _isRecording = true ; //since we start it now
          var p = new DateTime.now().millisecondsSinceEpoch.toString(); 
          var xpath = "storage/emulated/0/temp/test" + p;
          print(xpath);
          await FireRecorder.start(path: xpath, audioOutputFormat: AudioOutputFormat.AAC);


          setState(() {
            _isRecording = true ;
          });
        }
      }

  


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              '1You are recording',
            ),
            new Text(
              '$_isRecording',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _startRecording,
        tooltip: 'Start Recording',
        isExtended: true,
        backgroundColor: _isRecording ? Colors.red :  Colors.blue ,
        child: new Icon(Icons.mic),
        
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
