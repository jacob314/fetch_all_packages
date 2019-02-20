import Flutter
import UIKit

public class SwiftNativeAlertDialogPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "native_alert_dialog_plugin", binaryMessenger: registrar.messenger())
        let viewController = registrar.messenger() as! UIViewController
        let instance = SwiftNativeAlertDialogPlugin(viewController)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private final var viewController: UIViewController
    
    init(_ viewController: UIViewController){
        self.viewController = viewController
        
        super.init()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "showNativeDialog": showNativeDialog(call, result)
            
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    func showNativeDialog(_ call: FlutterMethodCall,_ result: @escaping FlutterResult){
        let arguments: [String: Any] = call.arguments as! [String: Any]
        let title: String = arguments["title"] as! String
        let body: String = arguments["body"] as! String
        let positiveButtonText: String = arguments["positiveButtonText"] as! String
        let negativeButtonText: String = arguments["negativeButtonText"] as! String
        let primaryColor: [String: NSNumber] = arguments["buttonColor"] as! [String: NSNumber]
        let color: UIColor? = parseColor(primaryColor)
        
        let dialogResultHandler: DialogResultHandler = DialogResultHandler(result)
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let positiveButton = UIAlertAction(title: NSLocalizedString(positiveButtonText, comment: "Default action"), style: .default, handler: { _ in
            dialogResultHandler.handleResult(true)
        })
        let negativeButton = UIAlertAction(title: NSLocalizedString(negativeButtonText, comment: "Default action"), style: .default, handler: { _ in
            dialogResultHandler.handleResult(false)
        })
        
        if color != nil {
            NSLog("color created %@", color!)
            
            positiveButton.setValue(color, forKey: "titleTextColor")
            negativeButton.setValue(color, forKey: "titleTextColor")
        }
        
        alert.addAction(positiveButton)
        alert.addAction(negativeButton)
        
        viewController.present(alert, animated: true, completion: {
            dialogResultHandler.handleResult(false)
        })
    }
    
    func parseColor(_ color: [String: NSNumber]?) -> UIColor? {
        if color == nil {
            return nil
        } else {
            let red: NSNumber? = color!["red"]
            let green: NSNumber? = color!["green"]
            let blue: NSNumber? = color!["blue"]
            let alpha: NSNumber? = color!["alpha"]
            if red == nil || green == nil || blue == nil || alpha == nil {
                return nil
            } else {
                return UIColor(red: CGFloat(red!.floatValue / 255), green: CGFloat(green!.floatValue / 255), blue: CGFloat(blue!.floatValue / 255), alpha: CGFloat(alpha!.floatValue / 255))
            }
        }
    }
    
    class DialogResultHandler {
        private var result: FlutterResult
        
        private var resultSent: Bool = false
        
        init(_ result: @escaping FlutterResult) {
            self.result = result
        }
        
        public func handleResult(_ result: Bool){
            if !resultSent {
                resultSent = true
                self.result(result)
            }
        }
    }
}
