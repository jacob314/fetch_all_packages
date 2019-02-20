import 'dart:async';

import 'package:flutter/services.dart';

class ContactPlugin {
  static const MethodChannel _channel =
      const MethodChannel('contact_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map> get selectContact async {
    final Map contactInfo = await _channel.invokeMethod('selectContact');
    return contactInfo;
  }

  static Future createNewContact(String phone) async {
    await _channel.invokeMethod('createNewContact');
  }

  static Future addToExistingContacts(String phone) async {
    await _channel.invokeMethod('addToExistingContacts');
  }

  static Future<List> get accessContacts async {
    final List contacts = await _channel.invokeMethod("accessContacts");
    return contacts;
  }

  static Future<List> get accessSectionContacts async {
    final List sectionContacts = await _channel.invokeMethod("accessSectionContacts");
    return sectionContacts;
  }
}
