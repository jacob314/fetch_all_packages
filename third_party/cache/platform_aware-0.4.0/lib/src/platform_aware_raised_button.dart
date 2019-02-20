import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareRaisedButton extends PlatformAwareWidget {
  final Key key;
  final VoidCallback onPressed;
  final Widget child;

  PlatformAwareRaisedButton(
      {this.key, @required this.onPressed, @required this.child});

  @override
  Widget buildAndroid(BuildContext context) =>
      new RaisedButton(onPressed: onPressed, child: child);

  @override
  Widget buildCupertino(BuildContext context) => new Container(
          child: new CupertinoButton(
        child: child,
        onPressed: onPressed,
        color: Theme.of(context).accentColor,
      ));
}
