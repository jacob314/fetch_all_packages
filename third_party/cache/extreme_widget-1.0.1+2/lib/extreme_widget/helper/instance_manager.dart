import 'dart:collection';

class InstanceManager {
  static Map<String, Object> instanceList = HashMap<String, Object>();

  static dynamic getInstance(instanceName) {
    return instanceList[instanceName];
  }

  static setInstance(instanceName,instance) {
    instanceList[instanceName] = instance;
  }
}
