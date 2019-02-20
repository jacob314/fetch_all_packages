/// Copyright (c) 2019, Steve Rogers. All rights reserved. Use of this source code
/// is governed by an Apache License 2.0 that can be found in the LICENSE file.
import 'dart:async';
import 'package:flutter/services.dart';

/// A Simple plug-in that can be used to interogate a device( iOS or Android) to obtain a list of current set up locales
///
/// The currentl default locale should be the first in the list
class Devicelocale {
  static const MethodChannel _channel =
      const MethodChannel('uk.spiralarm.flutter/devicelocale');

  /// Returns a 'List' of locales from the device
  ///
  /// for example **['en-GB', 'es-GB']**
  static Future<List> get preferredLanguages async {
    final List version = await _channel.invokeMethod('preferredLanguages');
    return version;
  }
}
