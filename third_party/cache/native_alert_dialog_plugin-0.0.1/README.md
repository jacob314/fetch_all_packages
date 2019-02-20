[![pub package](https://img.shields.io/pub/v/native_alert_dialog_plugin.svg)](https://pub.dartlang.org/packages/native_alert_dialog_plugin) 

# native_alert_dialog_plugin

Basic plugin to create native alert dialog

```dart
import 'package:native_alert_dialog_plugin/native_alert_dialog_plugin.dart';

//return user selection true for positive else false
Future<bool> showNativeDialog({
  String title, 
  String body,
  String positiveButtonText,
  String negativeButtonText,
  Color buttonColor,
})
```
