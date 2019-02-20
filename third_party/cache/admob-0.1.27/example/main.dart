import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admob/admob.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _showInterstitialResponse = "";
  var _loadInterstitialResponse = "";
  var _BannerState = "";

  String APP_ID = "ca-app-pub-9929690287684724~2116069294";
  String INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-9929690287684724/7809349294";
  String DEVICE_ID = "FF18F6CCC658F56ECA4C4623DB5082CA";
  bool TESTING = true;
  String PLACEMENT = "Top";

  @override
  initState() {
    super.initState();
    loadInterstitialAd();
  }

  loadInterstitialAd() async {
    String loadResponse = "";
    try {
      loadResponse = await Admob.loadInterstitial(APP_ID, INTERSTITIAL_AD_UNIT_ID, DEVICE_ID, TESTING);
    } on PlatformException {
      loadResponse = "Failed to Load";
    }
    setState(() {
      _loadInterstitialResponse = loadResponse;
    });
  }

  showInterstitialAd() async {
    var showResponse = "";
    try {
      showResponse = await Admob.showInterstitial;
    } on PlatformException {
      showResponse = false;
    }
    setState(() {
      _showInterstitialResponse = showResponse;
    });
  }

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


  final List<String> _items = ['Interstitial','Top Banner', 'Bottom Banner'].toList();
  String _selection = "Interstitial";
  @override
  Widget build(BuildContext context) {

    final dropdownMenuOptions = _items.map((String item) =>
       new DropdownMenuItem<String>(value: item, child: new Text(item))
    ).toList();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Plugin example app'),
      ),
      body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  new Text(_BannerState),
                  new DropdownButton<String>(
                  value: _selection,
                      items: dropdownMenuOptions,
                      onChanged: (s) {
                        setState(() {
                          _selection = s;
                          if(s == "Interstitial"){showInterstitialAd();}
                          if(s == "Top Banner"){
                            PLACEMENT = "Top";
                            if(_BannerState == "ShowingBottom"){closeBannerAd();}
                            if(_BannerState != "ShowingTop"){showBannerAd();}
                            else{closeBannerAd();}
                          }
                          if(s == "Bottom Banner"){
                            PLACEMENT = "Bottom";
                            if(_BannerState == "ShowingTop"){closeBannerAd();}
                            if(_BannerState != "ShowingBottom"){showBannerAd();}
                            else{closeBannerAd();}
                          }
                        });
                      }
                  )
            ]
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          print(_BannerState);
          if(_BannerState != "Shown"){showBannerAd();}
          else{closeBannerAd();}
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
