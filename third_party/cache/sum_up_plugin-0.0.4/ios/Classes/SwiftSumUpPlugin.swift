import Flutter
import UIKit
import SumUpSDK
import Foundation


public class SwiftSumUpPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sum_up_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftSumUpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    SumUpSDK.setup(withAPIKey: "d1d722ae-806c-4cf8-b8cb-cf31ac51a30f")
    SumUpSDK.testIntegration()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let vc: FlutterViewController = UIApplication.shared.delegate?.window??.rootViewController  as? FlutterViewController else {return}

    switch call.method {
      case "login":

      if let args = call.arguments as? [String: String],
      let token = args["token"] as? String {
        login(token: token) { (res, error) in
                print("Res: \(res), Error: \(error)")
                if let error = error {
                    result(FlutterError(code: "100", message: "Failed to LogIn with \(token)", details: error.localizedDescription))
                }
                if let res = res, res {
                    result("Successfully")
                }
                else{
                    result("Res: \(res), Error: \(error)")
                }
            }
        }
        else{
            result("bug")
        }

      case "prepareTransaction":
        if let args = call.arguments as? [String: String],
                    let totalPrice = args["totalPrice"] as? String {
                    initPayment(vc:vc, result:result, totalPrice:totalPrice)
                   }
        case "paymentPreferences":
              presentCheckoutController(vc:vc, result:result)
      case "getPlatformVersion":
            result("Ios")
      case "isSumUpTokenValid":
        if(getCurrentMerchantInfo() == nil){
            result(false);
        }
        else{
            result(true);
        }
      default:
        break
    }
    return
    }

  public func login(token: String, completion: @escaping (Bool?, Error?) -> ()){
    SumUpSDK.login(withToken:token, completion: {(result, error) in
         completion(result, error)
    })
  }

  public func prepareTransaction(totalPrice : String , result: @escaping FlutterResult) -> CheckoutRequest?{
    guard let currencyCode: String =  SumUpSDK.currentMerchant?.currencyCode else {
        result(FlutterError(code: "404", message: "not logged in", details: "You must logged in before"))
        return nil
    }


    let request = CheckoutRequest(
        total: NSDecimalNumber(string: totalPrice),
        title: "your title",
        currencyCode: currencyCode,
        paymentOptions: PaymentOptions.cardReader);

    return request;
  }

  public func initCheckout(request:CheckoutRequest, vc: FlutterViewController, result: @escaping FlutterResult ){
      guard let request: CheckoutRequest =  request else {return}
      SumUpSDK.checkout(
                with: request,
                from: vc){ [weak self] (checkoutResult: CheckoutResult?, error: Error?) in
             if let safeError = error as NSError? {
                 if (safeError.domain == SumUpSDKErrorDomain) && (safeError.code == SumUpSDKError.accountNotLoggedIn.rawValue) {
                     result(FlutterError(code: String(safeError.code), message: "not logged in", details: "You must logged in before"))
                 } else {
                     result(FlutterError(code: String(safeError.code), message: "general error", details: "no additional information"))
                 }
                 return
             }

             guard let safeResult = checkoutResult else {
                 return
             }

             if safeResult.success {
                 var message = "Thank you - \(String(describing: safeResult.transactionCode))"
                 if let info = safeResult.additionalInfo,
                     let tipAmount = info["tip_amount"] as? Double, tipAmount > 0,
                     let currencyCode = info["currency"] as? String {
                     message = message.appending("\n tip: \(tipAmount) \(currencyCode)")
                 }
                 result(message)
             } else {
                 result("No charge (cancelled)")
             }
         }
  }

  public func initPayment(vc: FlutterViewController, result: @escaping FlutterResult, totalPrice:String){
    if let req: CheckoutRequest = prepareTransaction(totalPrice:totalPrice, result:result) {
        initCheckout(request:req, vc:vc, result: result)
    }
  }

  public func presentCheckoutController(vc: FlutterViewController, result: @escaping FlutterResult){
        SumUpSDK.presentCheckoutPreferences(from: vc, animated: true){ [weak self]  (res, presentationError) in

               guard let safeError = presentationError as NSError? else {
                    result("Successfully")
                    return
               }

               let errorMessage: String
               let errorCode: String
               switch (safeError.domain, safeError.code) {
               case (SumUpSDKErrorDomain, SumUpSDKError.accountNotLoggedIn.rawValue):
                   errorMessage = "not logged in"
                     errorCode = String(safeError.code)
               case (SumUpSDKErrorDomain, SumUpSDKError.checkoutInProgress.rawValue):
                   errorMessage = "checkout is in progress"
                   errorCode = String(safeError.code)
               default:
                   errorMessage = "general error"
                   errorCode = String(safeError.code)

               }
               result(FlutterError(code: errorCode, message: errorMessage, details: safeError.localizedDescription))

          }
  }

  public func getCurrentMerchantInfo() -> Merchant?{
    return SumUpSDK.currentMerchant
  }
}
