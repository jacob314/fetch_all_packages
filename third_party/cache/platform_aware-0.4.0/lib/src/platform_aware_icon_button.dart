import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareIconButton extends PlatformAwareWidget {
  final Key keyValue;
  final Icon icon;
  final String tooltip;
  final double iconSize;
  final VoidCallback onPressed;

  PlatformAwareIconButton(
      {this.keyValue,
      @required this.icon,
      @required this.tooltip,
      this.iconSize = 24.0,
      @required this.onPressed});

  @override
  Widget buildAndroid(BuildContext context) => new IconButton(
      key: keyValue,
      iconSize: iconSize,
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed);

  @override
  Widget buildCupertino(BuildContext context) => new Container(
      key: keyValue,
      child: new CupertinoButton(
          padding: EdgeInsets.zero,
          child: new Tooltip(
              message: tooltip,
              child: IconTheme.merge(
                data: new IconThemeData(size: iconSize),
                child: icon,
              )),
          onPressed: onPressed));
}
