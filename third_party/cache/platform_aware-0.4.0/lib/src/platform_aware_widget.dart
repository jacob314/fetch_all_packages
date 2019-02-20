import 'package:flutter/material.dart';

abstract class PlatformAwareWidget extends StatelessWidget {
  Widget buildCupertino(BuildContext context) => buildAndroid(context);

  Widget buildFuchsia(BuildContext context) => buildAndroid(context);

  Widget buildAndroid(BuildContext context);

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return buildCupertino(context);
      case TargetPlatform.fuchsia:
        return buildFuchsia(context);
      case TargetPlatform.android:
        return buildAndroid(context);
    }

    return null;
  }
}
