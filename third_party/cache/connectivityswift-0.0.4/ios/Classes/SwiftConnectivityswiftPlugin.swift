import Flutter
import UIKit
import Reachability

let reachability = Reachability()!

public class SwiftConnectivityswiftPlugin: NSObject, FlutterPlugin {
    var eventSink: FlutterEventSink!
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.flutter.io/connectivity", binaryMessenger: registrar.messenger())
    let instance = SwiftConnectivityswiftPlugin()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    let streamChannel = FlutterEventChannel(name: "plugins.flutter.io/connectivity_status", binaryMessenger: registrar.messenger())
    streamChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
    
    func getWifiName() -> String? {
        return nil
    }
    
    func status(from reachability: Reachability) -> String? {
        let status = reachability.connection
        if status == .wifi {
            return "wifi"
        } else if status == .cellular {
            return "mobile"
        }else {
            return "none"
        }
    }
    
    @objc func reachabilityChanged (note: Notification) {
        eventSink(status(from: reachability));
    }
}

extension SwiftConnectivityswiftPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events;
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        return nil;
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self)
        eventSink = nil;
        return nil;
    }
}
