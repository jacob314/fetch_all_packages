# CARP Communication Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_communication_package.svg)](https://pub.dartlang.org/packages/carp_communication_package)

This library contains a sampling package for communication to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/core/Measure-class.html) types:

* `phone_log`
* `telephony`
* `text-message-log`
* `text-message`

See the [wiki]() for further documentation, particularly on available [probes](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Probes)
and [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#sampling-schema).


For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Extending) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^0.3.0
  carp_communication_package: ^0.3.0
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name>"
    xmlns:tools="http://schemas.android.com/tools">

   ...
   
   <!-- The following permissions are used for CARP Mobile Sensing -->
   <uses-permission android:name="android.permission.CALL_PHONE"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
   <uses-permission android:name="android.permission.READ_PHONE_NUMBERS"/>
   <uses-permission android:name="android.permission.READ_SMS"/>

</manifest>
````

### iOS Integration

No changes should be needed regarding permission in the `Info.plist` for this package.

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_comunication_package/context.dart';
`````

Before creating a study and running it, register this package in the 
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
  SamplingPackageRegistry.register(CommunicationSamplingPackage());
`````
