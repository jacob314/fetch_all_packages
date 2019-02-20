import 'dart:collection';

class Input {
  static Map<String, Object> exInstanceList = new HashMap<String, Object>();

  static setValue(inputName, value) {
    exInstanceList["${inputName}_value"] = value;
  }

  static String getValue(inputName) {
    return exInstanceList["${inputName}_value"];
  }
}
