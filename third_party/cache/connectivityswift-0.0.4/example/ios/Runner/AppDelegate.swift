import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
    let dict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
    
    if let CoachMarksDict = dict["UISupportedInterfaceOrientations"] {
        print("Info.plist : \(CoachMarksDict)")
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
