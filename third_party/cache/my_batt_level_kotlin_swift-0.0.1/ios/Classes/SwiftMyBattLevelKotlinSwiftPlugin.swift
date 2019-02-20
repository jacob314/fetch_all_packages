import Flutter
import UIKit

public class SwiftMyBattLevelKotlinSwiftPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "my_batt_level_kotlin_swift", binaryMessenger: registrar.messenger())
    let instance = SwiftMyBattLevelKotlinSwiftPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
