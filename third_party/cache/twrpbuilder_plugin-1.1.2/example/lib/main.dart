import 'package:flutter/material.dart';
import 'dart:async';

import 'package:twrpbuilder_plugin/twrpbuilder_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _rootAccess = false;
  String dirStatus = "";
  String _brand = "";
  String _board = "";
  String _abi = "";
  String _fingerPrint= "";
  String _model = "'";
  String _product = "";

  @override
  void initState() {
    super.initState();
    initRootRequest();
    _loadDeviceDetails();
  }

  Future<void> initRootRequest() async {
    bool rootAccess = await TwrpbuilderPlugin.rootAccess;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _rootAccess = rootAccess;
    });
  }

  Future<void> _createDir() async {
    if(_rootAccess){
      ///Please grant storage permissions in Settings
      //_showLoading();

      String propData = await TwrpbuilderPlugin.buildProp;

      await TwrpbuilderPlugin.createBuildProp('build.prop', propData);

      dirStatus = await TwrpbuilderPlugin.mkDir('TWRPBuilderF');

      //await TwrpbuilderPlugin.cp('/system/build.prop', 'TWRPBuilderF/build.prop');
      bool isOldMtk = await TwrpbuilderPlugin.isOldMtk;
      String recoveryMount = await TwrpbuilderPlugin.getRecoveryMount();
      print(isOldMtk);
      print(recoveryMount);
      //Navigator.of(context).pop(); ///Dismiss Loading dialog

    }
  }

  Future<Null> _showLoading() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                height: 60.0,
                width: 60.0,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(left: 8.0, right: 8.0)),
                    Text('Please wait...')
                  ],
                ),
              )
          );
        });
  }

  Future<Null> _loadDeviceDetails() async {
    //_showLoading();
    String brand = await TwrpbuilderPlugin.getBuildBrand;
    String board = await TwrpbuilderPlugin.getBuildBoard;
    String abi = await TwrpbuilderPlugin.getBuildAbi;
    String fingerPrint = await TwrpbuilderPlugin.getBuildFingerprint;
    String model = await TwrpbuilderPlugin.getBuildModel;
    String product = await TwrpbuilderPlugin.getBuildProduct;

    setState(() {
      _brand = brand;
      _board = board;
      _abi = abi;
      _fingerPrint = fingerPrint;
      _model = model;
      _product = product;
      //Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
          appBar: AppBar(
            title: Text('Bull'),
          ),
          body: Container(
            padding: EdgeInsets.all(16.0),
            height: 480.0,
            width: 320.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ListTile(
                  title: Text('Brand', style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                  subtitle: Text(_brand, style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600)),
                ),
                ListTile(
                  title: Text('Board', style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                  subtitle: Text(_board, style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600)),
                ),
                ListTile(
                  title: Text('Model', style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                  subtitle: Text(_model, style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600)),
                ),
                ListTile(
                  title: Text('Product', style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                  subtitle: Text(_product, style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: _createDir,
                      color: Colors.blue,
                      child: Text('Backup'),
                    ),
                  ],
                ),
              ],
            ),
          )
      ));
  }

}
