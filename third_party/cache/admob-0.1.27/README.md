# Admob for Flutter

A GoogleAdmob plugin for Flutter. Currently supports interstitial ads in both iOS and Android.

## Getting Started
The plugin contains two methods for loading and showing interstitial ads. In order to use them we must first import a couple of packages:  

```dart
import 'package:admob/admob.dart';
import 'package:flutter/services.dart';
```

##### [iOS DEVELOPERS NOTE: Developed for Objective C. You cannot use 'use_frameworks' in your new project's podfile]

### Interstitial Ads
Interstitial ads will display on both Android and iOS devices. In order to display our ads we need to pass Admob a few parameters. For more info on the app id and ad unit id visit http://google.com/admob.

```dart
String APP_ID = "Your APP ID";
String AD_UNIT_ID = "Your Ad_unit_id";
String DEVICE_ID = "Only necessary for testing: The device id you are testing with";
bool TESTING = A boolean declaring whether you are testing ads or live;
```

#### Async Methods
There are two asynchronous functions that we use, one to load the ad and one to show it. 

The plugin's loadInterstitial method accepts an APP_ID, AD_UNIT_ID, DEVICE_ID, and TESTING. The loadInterstitial method should be called in an init method to load an ad as the app starts. After that the ads will reload themselves whenever you close the previous one. The plugin's showInterstitial method accepts no variables, and as the name implies shows the ad you loaded with loadInterstitial. If the ad is not yet loaded the showInterstitial method will return false. 

```dart
@override
  initState(){
    super.initState();
    loadInterstitialAd();
  }
  
  loadInterstitialAd() async {
    bool loadResponse;
    try {
      loadResponse = await Admob.loadInterstitial(APP_ID, AD_UNIT_ID, DEVICE_ID, TESTING);
    } on PlatformException {
      loadResponse = false;
    }
    setState(() {
      _loadInterstitialResponse = loadResponse;
    });
  }

  showInterstitialAd() async {
    bool showResponse;
    try {
      showResponse = await Admob.showInterstitial;
    } on PlatformException {
      showResponse = false;
    }
    setState(() {
      _showInterstitialResponse = showResponse;
    });
  }
```

Now whenever we want to show the ad we simply call it: 

```dart
showInterstitialAd()
```

An example of how to do that: 

```dart
 @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Plugin example app'),
      ),
      body: new Center(child:new Text("$_showInterstitialResponse")),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => showInterstitialAd(),
        child: new Icon(Icons.add),
      ),
    );
  }
```

View the example code included with the plugin in the example folder to see usage. The main.dart file included in the example folder shows an implementation of the plugin.

### Banner Ads [iOS Only]
We currently have limited support for banner ads on the iOS platform. Banner ads work largely the same way as our interstitial do. Unlike interstitial there is no load function. Whenever we want a banner we simply call showBanner. The showBanner method accepts an extra variable over the loadInterstitial: 

The important new variable is PLACEMENT. You should pass either "Top" or "Bottom" in this variable when displaying a banner ad. This declares where the ad will be shown. 

```dart
  String APP_ID = "Your app id";
  String INTERSTITIAL_AD_UNIT_ID = "Your ad unit id";
  String DEVICE_ID = "(NOT REQD): Your device ID, to display test ads on a specific device";
  bool TESTING = A Boolean declaring whether ads should be live or testing;
  String PLACEMENT = "Top"
```
#### Banner Async Methods
We are now left needing our async functions. We have two of them, showBanner and closeBanner, they return a string that can be described as a banner state. If the ad is shown properly it returns "ShowingTop" or "ShowingBottom" depending on placement or else it returns "NotShown". A banner does not have to be closed. It is simple an option for people looking to display one temporarily: 

```dart
showBannerAd() async {
    var showResponse = "";
    try {showResponse = await Admob.showBanner(APP_ID, INTERSTITIAL_AD_UNIT_ID, DEVICE_ID, TESTING, PLACEMENT);}
    on PlatformException {showResponse = "Not Shown";}

    setState(() {
      _BannerState = showResponse;
    });
  }

  closeBannerAd() async {
    var showResponse = "";
    try {
      _BannerState = await Admob.closeBanner();
      print(_BannerState);
    } on PlatformException {
      showResponse = "Not Closed";
    }
    setState(() {
      _BannerState = showResponse;
    });
  }
```



### SUPPORT THE DEVELOPER  
##### BTC Address:13JN3yubwaPzyuBpj4MtKqirVfweq1b6Sc

