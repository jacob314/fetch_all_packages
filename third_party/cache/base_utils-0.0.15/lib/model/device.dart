// To parse this JSON data, do
//
//     final deviceInfo = deviceInfoFromJson(jsonString);

import 'dart:convert';

DeviceInfo deviceInfoFromJson(String str) {
  final jsonData = json.decode(str);
  return DeviceInfo.fromJson(jsonData);
}

String deviceInfoToJson(DeviceInfo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class DeviceInfo {
  String appVersion;
  String brand;
  String model;
  String os;
  String osVersion;
  String udid;

  DeviceInfo({
    this.appVersion,
    this.brand,
    this.model,
    this.os,
    this.osVersion,
    this.udid,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => new DeviceInfo(
        appVersion: json["appVersion"] == null ? null : json["appVersion"],
        brand: json["brand"] == null ? null : json["brand"],
        model: json["model"] == null ? null : json["model"],
        os: json["os"] == null ? null : json["os"],
        osVersion: json["osVersion"] == null ? null : json["osVersion"],
        udid: json["udid"] == null ? null : json["udid"],
      );

  Map<String, dynamic> toJson() => {
        "appVersion": appVersion == null ? null : appVersion,
        "brand": brand == null ? null : brand,
        "model": model == null ? null : model,
        "os": os == null ? null : os,
        "osVersion": osVersion == null ? null : osVersion,
        "udid": udid == null ? null : udid,
      };
}
