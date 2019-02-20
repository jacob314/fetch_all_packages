import Flutter
import UIKit
import AccountKit
    
@available(iOS 10.0, *)
public class SwiftPluginSocialPlugin: NSObject, FlutterPlugin, AKFViewControllerDelegate {

  static let CHANNEL_NAME = "plugin_social";
    var methodChanel = FlutterMethodChannel();
    var accountKit: AKFAccountKit?
    var viewController: UIViewController?

    init(channel: FlutterMethodChannel, viewController: UIViewController?) {
        self.methodChanel = channel;
        self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken);
        self.viewController = viewController
    }  

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let viewController: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        let instance = SwiftPluginSocialPlugin(channel: channel, viewController: viewController);
        
        registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "SignInWithSMS":
            showUISignInSMS();
            result(nil);
        case "SignInWithEmail":
            showUISignInEmail()
            result(nil);
        case "getCurrentAccessToken":
            print("getAccessToken");
        default:
            result(UIDevice.current.systemVersion)
        }
  }

  func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self

        //UI Theming - Optional
        loginViewController.uiManager = AKFSkinManager(skinType: .classic, primaryColor: UIColor.blue)
    }
    
    func showUISignInSMS() {
        let inputState = UUID().uuidString
        guard let vc = self.accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState) else {
            return
        }
        vc.enableSendToFacebook = true
        vc.whitelistedCountryCodes = ["VN"];
        self.prepareLoginViewController(loginViewController: vc)
       
        //UIAlertView(title: "RESULT", message: "ALERT", delegate: nil, cancelButtonTitle: "OK").show()
        
        self.viewController?.present(vc as UIViewController, animated: true, completion: nil);
    }
    
    func showUISignInEmail() {
        let inputState = UUID().uuidString
        guard let vc = self.accountKit?.viewControllerForEmailLogin(withEmail: nil, state: inputState) else {
            return
        }
        vc.enableSendToFacebook = true
        vc.whitelistedCountryCodes = ["VN"];
        self.prepareLoginViewController(loginViewController: vc)
        self.viewController?.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    public func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        guard let accountKit = self.accountKit else {
            return
        }
        
        accountKit.requestAccount({ (account, error) in
            
            guard let account = account else {
                return
            }
            
            var informations: [String: Any] = [:];
            informations["phone_number"] = account.phoneNumber?.phoneNumber;
            informations["access_token"] = accountKit.currentAccessToken?.tokenString;
            informations["email_address"] = account.emailAddress;
            
            UIAlertView(title: "RESULT", message: account.phoneNumber?.phoneNumber, delegate: nil, cancelButtonTitle: "OK").show()
            
            self.methodChanel.invokeMethod("didFinishLoggedIn", arguments: informations)
        })
    }    
}
