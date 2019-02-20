import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLib {
  static init() async {
    final Firestore firestore = Firestore();
    await firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static showNotification(Map<String, dynamic> msg) async {
    var android = AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = IOSNotificationDetails();
    //var platform = NotificationDetails(android, iOS);
    NotificationDetails(android, iOS);

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (notificationData) {
      print("NOTIFICATION CLICK!");
    });

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, msg["notification"]["title"],
        msg["notification"]["body"], platformChannelSpecifics,
        payload: 'item id 2');
  }

  static activateNotification() {
    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });

    firebaseMessaging.getToken().then((token) {
      update(token);
      print("registerd to topic: daanzel-notification");
      firebaseMessaging.subscribeToTopic("daanzel-notification");
    });
  }

  static update(String token) {
    Firestore.instance.collection('token').document().setData({'token': token});
    print("Token $token");
  }

  static FirebaseAuth auth = FirebaseAuth.instance;
  static Future<FirebaseUser> loginByEmail(email, password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("FirebaseLib.loginByEmail Error!");
      return null;
    }
  }
}
