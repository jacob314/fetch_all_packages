import 'package:flutter/material.dart';
import 'package:document_chooser/document_chooser.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<String> _documents = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Column(
          children: [
            getButton("Pick document", ()=>pickDocument()),
            getButton("Pick documents", ()=>pickDocuments()),
            Expanded(
              child: ListView(children: getDocuments(),),
            )
          ],
        ),
      ),
    );
  }

  Widget getButton(String text, Function action){
    return RaisedButton(
      onPressed: action,
      child: Text(text),
    );
  }

  pickDocument() async {
    String path = await DocumentChooser.chooseDocument();
    setState(()=>_documents = [path]);
  }

  pickDocuments() async {
    List<String> paths = await DocumentChooser.chooseDocuments();
    setState(()=>_documents = paths);
  }

  getDocuments() {
    return List.generate(_documents.length, (i) => Text(_documents[i]));
  }

}
