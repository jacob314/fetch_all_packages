import Flutter
import UIKit
import AdSupport

public class SwiftGetIosDeviceIdfaPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "get_ios_device_idfa", binaryMessenger: registrar.messenger())
    let instance = SwiftGetIosDeviceIdfaPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let advertisingIdentifier = ASIdentifierManager.init().advertisingIdentifier
    if advertisingIdentifier.hashValue != 0 {
      result(advertisingIdentifier.uuidString)
    } else {
      result(nil)
    }
  }
}