import Flutter
import UIKit

public class SwiftFlutterSweetAlertPlugin: NSObject, FlutterPlugin {
    static var opened:SweetAlert=SweetAlert(alertType: AlertStyle.none);
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_sweet_alert", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSweetAlertPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let method = call.method
    
    
    switch(method){
        case "showDialog":
            let dic = call.arguments as? [String: Any]
            let type = dic?["type"] as! Int
            var alertType=AlertStyle.none
            switch type {
            case 0:
                alertType=AlertStyle.none
            case 1:
                alertType=AlertStyle.error
            case 2:
                alertType=AlertStyle.success
            case 3:
                alertType=AlertStyle.warning
            case 4:
                alertType=AlertStyle.none
            case 5:
                alertType=AlertStyle.loading
            default:
                alertType=AlertStyle.none
            }
            
            let title = dic?["title"] as? String
            let content = dic?["content"] as? String
            let confirmButtonText = dic?["confirmButtonText"] as! String
            let showCancelButton = dic?["showCancelButton"] as! Bool
            let cancelButtonText = dic?["cancelButtonText"] as! String
            let cancelable = dic?["cancelable"] as! Bool
            let autoClose = dic?["autoClose"] as! Int
            //let closeWithAnimation = dic?["closeWithAnimation"] as! Bool
            let closeOnConfirm = dic?["closeOnConfirm"] as! Bool
            let closeOnCancel = dic?["closeOnCancel"] as! Bool
            var alert = SweetAlert(alertType: alertType);
            if(title != nil){
                alert=alert.setTitleText(title ?? "");
            }
            if (content != nil){
                alert=alert.setContentText(content ?? "");
            }
            alert=alert.setCancelButton(showCancelButton, cancelButtonText)
            if(type != 5){
                alert=alert.setConfirmButton(confirmButtonText);
            }

            alert=alert.setCancelable(cancelable);
            alert=alert.setCloseOnCancelClick(closeOnCancel)
            alert=alert.setCloseOnConfirmClick(closeOnConfirm)
            alert=alert.setAutoClose(Double(autoClose)/1000)
            
            SwiftFlutterSweetAlertPlugin.opened=alert.show(){
                (buttonIndex) -> Void in
                if buttonIndex == 0 {

                    result(false)
                }
                else if(buttonIndex==1){
                    result(true)
                }else{
                    
                }
            }
            
            
            
            break;
        case "updateDialog":
            print("updateDialog")
            let dic = call.arguments as? [String: Any]
            let type = dic?["type"] as! Int
            var alertType=AlertStyle.none
            switch type {
            case 0:
                alertType=AlertStyle.none
            case 1:
                alertType=AlertStyle.error
            case 2:
                alertType=AlertStyle.success
            case 3:
                alertType=AlertStyle.warning
            case 4:
                alertType=AlertStyle.none
            case 5:
                alertType=AlertStyle.loading
            default:
                alertType=AlertStyle.none
            }
            
            let title = dic?["title"] as? String
            let content = dic?["content"] as? String
            let confirmButtonText = dic?["confirmButtonText"] as! String
            let showCancelButton = dic?["showCancelButton"] as! Bool
            let cancelButtonText = dic?["cancelButtonText"] as! String
            let cancelable = dic?["cancelable"] as! Bool
            let autoClose = dic?["autoClose"] as! Int
            //let closeWithAnimation = dic?["closeWithAnimation"] as! Bool
            let closeOnConfirm = dic?["closeOnConfirm"] as! Bool
            let closeOnCancel = dic?["closeOnCancel"] as! Bool
            var alert = SweetAlert(alertType: alertType)
            if(title != nil){
                alert=alert.setTitleText(title ?? "");
            }else{
                alert=alert.setTitleText("");
            }
            if (content != nil){
                alert=alert.setContentText(content ?? "");
            }else{
                alert=alert.setContentText("");
            }
            alert.buttons=[]
            alert=alert.setAlertType(alertType)
            alert=alert.setCancelButton(showCancelButton, cancelButtonText)
            alert=alert.setConfirmButton(confirmButtonText);
            alert=alert.setCancelable(cancelable);
            
            alert=alert.setAutoClose(Double(autoClose)/1000)
            alert=alert.setCloseOnCancelClick(closeOnCancel)
            alert=alert.setCloseOnConfirmClick(closeOnConfirm)
            
            SwiftFlutterSweetAlertPlugin.opened=alert.update(){
                (buttonIndex) -> Void in
                if buttonIndex == 0 {
                    result(false)
                }
                else if(buttonIndex==1){
                    result(true)
                }else{

                }
            }
            
            
            
            break;
        case "close":
            SwiftFlutterSweetAlertPlugin.opened.closeAlert(-2)
        default:result(FlutterMethodNotImplemented);

    }
  }
}
