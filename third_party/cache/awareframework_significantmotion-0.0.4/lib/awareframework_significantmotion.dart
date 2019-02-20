import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';


/// The SignificantMotion measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = SignificantMotionSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  SignificantMotionSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = SignificantMotionSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<dynamic>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onSignificantMotionStart.listen((event) {
///   print(event)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = SignificantMotionCard(sensor: sensor);
/// ```
class SignificantMotionSensor extends AwareSensor {
  static const MethodChannel _significantMotionMethod =
    const MethodChannel('awareframework_significantmotion/method');

  // static const EventChannel  _significantMotionStream  =
  //  const EventChannel('awareframework_significantmotion/event');

  static const EventChannel  _significantMotionStartStream =
    const EventChannel("awareframework_significantmotion/event_on_significant_motion_start");

  static const EventChannel  _significantMotionEndStream =
    const EventChannel("awareframework_significantmotion/event_on_significant_motion_end");


  StreamController<dynamic> significantMotionStartStreamController = StreamController<dynamic>();
  StreamController<dynamic> significantMotionEndStreamController = StreamController<dynamic>();

  bool onSignificantMotion = false;

  /// Init SignificantMotion Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = SignificantMotionSensor.init(null);
  /// ```
  SignificantMotionSensor():this.init(null);

  /// Init SignificantMotion Sensor with SignificantMotionSensorConfig
  ///
  /// ```dart
  /// var config =  SignificantMotionSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = SignificantMotionSensor.init(config);
  /// ```
  SignificantMotionSensor.init(SignificantMotionSensorConfig config) : super(config){
    super.setMethodChannel(_significantMotionMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<dynamic>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onSignificantMotionStart.listen((event) {
  ///
  /// }
  ///
  Stream<dynamic> get onSignificantMotionStart {
    significantMotionStartStreamController.close();
    significantMotionStartStreamController = StreamController<dynamic>();
    return significantMotionStartStreamController.stream;
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<dynamic>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onSignificantMotionEnd.listen((event) {
  ///   print(event)
  /// }
  ///
  Stream<dynamic> get onSignificantMotionEnd {
    significantMotionEndStreamController.close();
    significantMotionEndStreamController = StreamController<dynamic>();
    return significantMotionEndStreamController.stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream(
        _significantMotionStartStream, "on_significant_motion_start"
    ).listen((event){
      onSignificantMotion = true;
      significantMotionStartStreamController.add(event);
    });

    super.getBroadcastStream(
        _significantMotionEndStream, "on_significant_motion_end"
    ).listen((event){
      onSignificantMotion = false;
      significantMotionEndStreamController.add(event);
    });

    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_significant_motion_start");
    super.cancelBroadcastStream("on_significant_motion_end");
    return super.stop();
  }
}


/// A configuration class of SignificantMotionSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  SignificantMotionSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class SignificantMotionSensorConfig extends AwareSensorConfig{

  SignificantMotionSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

///
/// A Card Widget of SignificantMotion Sensor
///
/// You can generate a Cart Widget by following code.
/// ```dart
/// var card = SignificantMotionCard(sensor: sensor);
/// ```
class SignificantMotionCard extends StatefulWidget {
  SignificantMotionCard({Key key, @required this.sensor}) : super(key: key);

  final SignificantMotionSensor sensor;

  @override
  SignificantMotionCardState createState() => new SignificantMotionCardState();
}

///
/// A Card State of SignificantMotion Sensor
///
class SignificantMotionCardState extends State<SignificantMotionCard> {

  String status = "Status: ";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onSignificantMotionStart.listen((event) {
      setState((){
        status = "Significant Motion Start";
      });
    });

    widget.sensor.onSignificantMotionEnd.listen((event) {
      setState((){
        status = "Significant Motion End";
      });
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text(status),
        ),
      title: "Significantmotion",
      sensor: widget.sensor
    );
  }
}
