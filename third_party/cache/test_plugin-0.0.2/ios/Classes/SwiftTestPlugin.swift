import Flutter
import UIKit

public class SwiftTestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutterplugins.markhamenterprises.com/test_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftTestPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "kickBack":
        let args = call.arguments as! [String:Any]
        let kick = args["kick"] as! String
        self.kickBack(result: result, kick: kick)
    default:
        result(FlutterMethodNotImplemented);
    }
  }

  private func kickBack(result: FlutterResult, kick:String){
    result(String("iOS Got it : \(kick)  "));
  }

}
