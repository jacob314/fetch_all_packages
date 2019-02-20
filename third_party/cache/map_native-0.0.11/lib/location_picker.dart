import 'dart:async';
import 'package:flutter/material.dart';
import 'map_native.dart';

typedef Future<LatLong> MyLocationGetter();

class LocationPickerPage extends StatefulWidget {
  final TextStyle okButtonTextStyle;
  final String okButtonText;

  final TextStyle titleTextStyle;
  final String titleText;

  final LatLong initialLocation;
  final inititialZoom;

  final MyLocationGetter myLocationGetter;

  LocationPickerPage(
      {this.okButtonTextStyle,
      this.okButtonText: "OK",
      this.titleTextStyle,
      this.titleText: "Pick a location",
      @required this.initialLocation,
      this.inititialZoom: 15.0,
      this.myLocationGetter});

  @override
  State<StatefulWidget> createState() {
    return new _LocationPickerPageState();
  }
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  double lat = 35.781924;
  double lng = 51.374914;
  double zoom = 15.0;
  final GlobalKey<MapViewState> _mapKey = new GlobalKey();

  @override
  void initState() {
    _goToMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    final cardMap = new Stack(
      children: [
        new MapView(
            key: _mapKey,
            initialLocation: new LatLong(lat, lng),
            inititialZoom: zoom),
        new Align(
            alignment: Alignment.bottomRight,
            child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new FloatingActionButton(
                    backgroundColor: theme.canvasColor,
                    onPressed: _goToMyLocation,
                    child: new Icon(Icons.my_location, color: primaryColor)))),
        new Center(
            child: new SizedBox(
                child: new Image.asset('assets/crossaim.png'),
                width: 48.0,
                height: 48.0)),
      ],
    );

    final okButton = new Container(
      margin: new EdgeInsets.all(16.0),
      child: new MaterialButton(
          minWidth: 320.0,
          color: primaryColor,
          onPressed: _onOK,
          textColor: Colors.white,
          height: 48.0,
          child:
              new Text(widget.okButtonText, style: widget.okButtonTextStyle)),
    );

    final column =
        new Column(children: <Widget>[new Expanded(child: cardMap), okButton]);

    final scaffold = new Scaffold(
        appBar: new AppBar(
            title: new Text(widget.titleText, style: widget.titleTextStyle)),
        body: column);

    return scaffold;
  }

  void _onOK() {
    final Map<String, double> result = {
      "latitude": _mapKey.currentState.location.lat,
      "longitude": _mapKey.currentState.location.long,
      "zoom": _mapKey.currentState.zoom,
    };
    Navigator.of(context).pop(result);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _goToMyLocation() async {
    if (widget.myLocationGetter == null) {
      return;
    }

    final location = await widget.myLocationGetter();
    // Platform messages may fail, so we use a try/catch PlatformException.

    setState(() {
      _mapKey.currentState.location = location;
      _mapKey.currentState.zoom = zoom;
    });
  }
}
