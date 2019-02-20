import Flutter
import UIKit
    
public class SwiftIceteaStudioUtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "icetea_studio_utils_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftIceteaStudioUtilsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
