import 'dart:async';

import 'package:connectivityswift/connectivityswift.dart';
import 'package:flutter/material.dart';
import 'package:settings/settings.dart';

abstract class NetworkAwareState<T extends StatefulWidget> extends State<T> {
  StreamSubscription _networkSubscription;

  GlobalKey<ScaffoldState> getScaffoldKey();

  void onReconnected();

  void onDisconnected();
  

  bool firstCallback = true;

  @override
  void initState() {
    super.initState();
    //listen to network changes
    _networkSubscription =
        Connectivityswift().onConnectivityChanged.listen((result) {
      if (firstCallback) {
        firstCallback = false;
        return;
      }

      if (result != ConnectivityResult.none) {
        onReconnected();
        setNoNetworkMessage(false);
      } else {
        onDisconnected();
        setNoNetworkMessage(true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _networkSubscription.cancel();
  }

  void setNoNetworkMessage(bool enabled) {
    if (getScaffoldKey() == null) {
      return;
    }

    if (enabled) {
      getScaffoldKey().currentState.showSnackBar(SnackBar(
            content: Text("Không có kết nối Internet"),
            duration: Duration(days: 999),
            action: SnackBarAction(
                label: "Cài Đặt",
                onPressed: () {
                  Settings.openWiFiSettings();
                }),
          ));
    } else {
      getScaffoldKey().currentState.removeCurrentSnackBar();
    }
  }
}
