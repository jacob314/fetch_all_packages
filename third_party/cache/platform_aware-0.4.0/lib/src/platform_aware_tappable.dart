import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareTappable extends PlatformAwareWidget {
  final VoidCallback onTap;
  final Widget child;

  PlatformAwareTappable({@required this.onTap, @required this.child});

  @override
  Widget buildCupertino(BuildContext context) => new GestureDetector(
        child: child,
        onTap: onTap,
      );

  @override
  Widget buildAndroid(BuildContext context) => new InkResponse(
        child: child,
        onTap: onTap,
      );
}
