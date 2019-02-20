import 'package:cloud_firestore/cloud_firestore.dart';

class FlutterBackgroundGeoLocation {
  static void initBackgroundGeoLocation() {
    //bg.BackgroundGeolocation.stop();

    // bg.BackgroundGeolocation.onLocation((bg.Location location) async {
    //   print("Let's save it to database from onLocation!");
    //   saveToFirebase(location);
    // });

    // bg.BackgroundGeolocation.onMotionChange((bg.Location location) async {
    //   print("Let's save it to database from onMotionChange!");
    //   saveToFirebase(location);
    // });

    // bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
    //   print('[providerchange] - $event');
    // });

    // bg.BackgroundGeolocation.ready(bg.Config(
    //   desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    //   distanceFilter: 10.0,
    //   stopOnTerminate: false,
    //   startOnBoot: true,
    //   debug: true,
    //   logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    //   notificationText: "MonitoringApp Location Activated",
    //   notificationTitle: "MonitoringApp",
    //   reset: true,
    // )).then((bg.State state) {
    //   if (!state.enabled) {
    //     bg.BackgroundGeolocation.start();
    //   }
    // });
  }

  static void saveToFirebase(location) async {
    print("${location.coords.latitude}");
    print("${location.coords.longitude}");
    await Firestore.instance.collection('userRouteHistory').document().setData({
      'lat': location.coords.latitude,
      'lng': location.coords.longitude,
      'date': DateTime.now(),
    }).then((value) {
      print("Saved to Firebase!");
    });
  }

  static void saveCurrentGeoLocationToFirebase() {
    print("Save geoLocation with saveCurrentGeoLocationToFirebase!");
    // bg.BackgroundGeolocation.getCurrentPosition();
  }
}
