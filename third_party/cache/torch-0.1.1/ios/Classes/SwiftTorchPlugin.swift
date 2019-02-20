import Flutter
import UIKit
import AVFoundation

public class SwiftTorchPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "io.siteplan.flutterplugins/torch", binaryMessenger: registrar.messenger())
        let instance = SwiftTorchPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "turnOn":
            turn(on: true)
            break
        case "turnOff":
            turn(on: false)
            break
        case "hasTorch":
            result(hasTorch())
            break
        default:
            print("error")
        }
    }

    private func hasTorch() -> Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return false }
        return device.hasTorch
    }
    
    private func turn(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }    
    }
}
