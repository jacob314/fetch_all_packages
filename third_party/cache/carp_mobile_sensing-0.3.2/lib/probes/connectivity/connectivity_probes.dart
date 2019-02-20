/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// The [ConnectivityProbe] listens to the connectivity status of the phone and
/// collect a [ConnectivityDatum] every time the connectivity state changes.
class ConnectivityProbe extends StreamProbe {
  //ConnectivityProbe(Measure measure) : super(measure, connectivityStream);
  ConnectivityProbe() : super(connectivityStream);
}

Stream<Datum> get connectivityStream => Connectivity()
    .onConnectivityChanged
    .map((ConnectivityResult event) => ConnectivityDatum.fromConnectivityResult(event));

// This probe requests access to location PERMISSIONS (on Android). Don't ask why.....
// TODO - implement request for getting permission.

// TODO - need to reimplement this probe -- taking into consideration if BT is available and only start scans when asked...

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and collect
/// a [BluetoothDatum] for each. Uses a [PeriodicMeasure] for configuration the
/// [frequency] and [duration] of the scan.
class BluetoothProbe extends PeriodicStreamProbe {
  /// Default timeout for bluetooth scan - 2 secs
  static const DEFAULT_TIMEOUT = 2 * 1000;

//  BluetoothProbe(PeriodicMeasure measure)
//      : super(
//            measure,
//            FlutterBlue.instance
//                .scan(
//                    scanMode: ScanMode.lowLatency, timeout: Duration(milliseconds: measure.duration ?? DEFAULT_TIMEOUT))
//                .map((result) => BluetoothDatum.fromScanResult(result)));

  BluetoothProbe()
      : super(FlutterBlue.instance
            .scan(scanMode: ScanMode.lowLatency, timeout: Duration(milliseconds: DEFAULT_TIMEOUT))
            .map((result) => BluetoothDatum.fromScanResult(result)));

  // important that we don't propagate this up the chain, since this would close the overall stream
  @override
  void onDone() {}
}
