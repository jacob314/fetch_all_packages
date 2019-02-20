import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _productIds = [];
  List<String> _alreadyPurchased = [];

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    // Android testers: You can use "android.test.purchased" to simulate a successful flow.
    List<String> productIds = ["com.example.testiap"];

    IAPResponse response = await FlutterIap.fetchProducts(productIds);
    productIds = response.products
        .map((IAPProduct product) => product.productIdentifier)
        .toList();

    IAPResponse purchased = await FlutterIap.fetchInventory();
    List<String> purchasedIds = purchased.purchases
        .map((IAPPurchase purchase) => purchase.productIdentifier)
        .toList();

    if (!mounted) return;

    setState(() {
      _productIds = productIds;
      _alreadyPurchased = purchasedIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    String nextPurchase = _productIds.firstWhere(
      (id) => !_alreadyPurchased.contains(id),
      orElse: () => null,
    );

    List<Text> list = [];
    _alreadyPurchased.forEach((productId) {
      list.add(new Text(productId));
    });

    if (list.isEmpty) {
      list.add(new Text("No previous purchases found."));
    } else {
      list.insert(0, new Text("Already purchased:"));
    }

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("flutter_iap example app"),
        ),
        body: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                _productIds.isNotEmpty
                    ? "Available Products to purchase: $_productIds"
                    : "Not working?\n"
                    "Check that you set up in app purchases in\n"
                    "iTunes Connect / Google Play Console",
                textAlign: TextAlign.center,
                textScaleFactor: 1.25,
              ),
              new SizedBox(
                height: 24.0,
              ),
            ].followedBy(list).toList(),
          ),
        ),
        floatingActionButton: nextPurchase != null
            ? new FloatingActionButton(
                child: new Icon(Icons.monetization_on),
                onPressed: () async {
                  IAPResponse response = await FlutterIap.buy(nextPurchase);
                  if (response.purchases != null) {
                    List<String> purchasedIds = response.purchases
                        .map((IAPPurchase purchase) => purchase.productIdentifier)
                        .toList();

                    setState(() {
                      _alreadyPurchased = purchasedIds;
                    });
                  }
                },
              )
            : new Container(),
      ),
    );
  }
}
