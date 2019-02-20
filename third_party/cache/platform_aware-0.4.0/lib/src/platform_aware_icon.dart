import 'package:flutter/cupertino.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareIcon extends PlatformAwareWidget {
  final IconData icon;

  PlatformAwareIcon(this.icon);

  @override
  Widget buildCupertino(BuildContext context) => new Icon(
        icon,
        color: CupertinoColors.activeBlue,
      );

  @override
  Widget buildAndroid(BuildContext context) => new Icon(icon);
}
