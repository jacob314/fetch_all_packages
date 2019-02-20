import Flutter
import UIKit
import Stripe
import RxSwift

public class SwiftFlutterStripePlugin: NSObject {
    
    private lazy var disposeBag = DisposeBag()
    
    private var transactionToken: String?
    private var handlingNativePayResult: FlutterResult?
}

extension SwiftFlutterStripePlugin: FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_stripe", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterStripePlugin()
        STPPaymentConfiguration.shared().publishableKey = "pk_test_pHzj1pASIO4PwqVZ7LtKfxuR"
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let type = FlutterStripeAPIType(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
    }
}
