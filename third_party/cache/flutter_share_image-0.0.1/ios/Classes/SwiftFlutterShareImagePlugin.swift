import Flutter
import UIKit

public class SwiftFlutterShareImagePlugin: NSObject, FlutterPlugin {
  private var result: FlutterResult?
  private var viewController: UIViewController?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_share_image", binaryMessenger: registrar.messenger())
    let viewController: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
    let instance = SwiftFlutterShareImagePlugin(viewController: viewController)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  init(viewController: UIViewController?) {
    super.init()
    self.viewController = viewController
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (self.result != nil) {
      self.result!(FlutterError(code: "multiple_request", message: "Cancelled by a second request", details: nil))
      self.result = nil
    }
    
    if ("shareImage" == call.method) {
      self.result = result
      let args = call.arguments as? [String: Any?]
      let title = args!["title"] as? String
      let fileUrl = args!["fileUrl"] as? String
      var sharedItems : Array<NSObject> = Array()
      
      // Set file url
      if (fileUrl != nil && fileUrl != "") {
        let filePath = URL(fileURLWithPath: fileUrl!)
        sharedItems.append(filePath as NSObject);
      }
      
      let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
      
      // Set sharing activity title
      if (title != nil && title != "") {
        activityViewController.setValue(title, forKeyPath: "subject");
      }
      
      DispatchQueue.main.async {
        self.viewController?.present(activityViewController, animated: true, completion: nil)
      }
      result(true)
    }
    else {
      result(FlutterMethodNotImplemented)
    }
  }
}
