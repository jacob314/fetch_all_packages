import Flutter
import UIKit

public class SwiftPhotoProviderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "top.sp0cket.photo_provider", binaryMessenger: registrar.messenger())
    let instance = SwiftPhotoProviderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
        PhotoProvider.shared.initPhotoProvider()
    case "hasPermission":
        result(PhotoProvider.shared.hasPermission)
    case "imagesCount":
        result(PhotoProvider.shared.photosCount)
    case "getImage":
        guard let arg = call.arguments as? [String: Any] else { return }
        guard let index = arg["index"] as? Int else { return }
        PhotoProvider.shared.getImage(at: index,
                                     width: arg["width"] as? Int,
                                     height: arg["height"] as? Int,
                                     compress: arg["compress"] as? Int,
                                     result: result)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
