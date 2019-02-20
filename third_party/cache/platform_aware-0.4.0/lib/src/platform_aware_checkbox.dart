import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareCheckbox extends PlatformAwareWidget {
  final Key keyValue;
  final bool value;
  final ValueChanged<bool> onChanged;

  PlatformAwareCheckbox(
      {this.keyValue, @required this.value, @required this.onChanged});

  @override
  Widget buildCupertino(BuildContext context) => new CupertinoSwitch(
        key: keyValue,
        value: value,
        onChanged: onChanged,
      );

  @override
  Widget buildAndroid(BuildContext context) => new Checkbox(
        key: keyValue,
        value: value,
        onChanged: onChanged,
      );
}
