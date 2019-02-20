import 'dart:collection';

import 'package:flutter/material.dart';

class ExInstanceManager {
  static Map<String, Object> instanceList = HashMap<String, Object>();

  static dynamic getInstance(instanceName) {
    return instanceList[instanceName];
  }

  static setInstance(instanceName, instance) {
    instanceList[instanceName] = instance;
  }

  static TextEditingController textEditingController(String widgetId) {
    TextEditingController textEditingController =
        ExInstanceManager.getInstance("${widgetId}_textEditingController");
    return textEditingController;
  }
}
