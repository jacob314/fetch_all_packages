import Flutter
import UIKit
import AVFoundation
    
public class SwiftCanaryRecorderPlugin: NSObject, FlutterPlugin {
    
    fileprivate let TAG = "PCMRecorder"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "canary_recorder", binaryMessenger: registrar.messenger())
        let instance = SwiftCanaryRecorderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            
        case "initializeRecorder":
            guard let ref = call.arguments as? [String:Any],
                  let file = ref["outputFile"] as? String else { result(FlutterError(code: "PARAMETER_ERROR", message: "Parameter not given or was an incorrect type.", details: nil)); return }
            initializeRecorder(result, outputFile: file)
            break;
            
        case "startRecording":
            startRecording(result)
            break;
            
        case "stopRecording":
            stopRecording(result)
            break;
            
        default:
            result(FlutterMethodNotImplemented)
            
        }
    }

}

// MARK: Method Call Handlers

extension SwiftCanaryRecorderPlugin {
    
    fileprivate func initializeRecorder(_ result: @escaping FlutterResult, outputFile: String) {
        let path = RecordingManager.sharedInstance.prepare(filename: outputFile);
        print("[\(TAG)] Recorder initialized.")
        result(path);
    }
    
    fileprivate func startRecording(_ result: @escaping FlutterResult) {
        RecordingManager.sharedInstance.start();
        print("[\(TAG)] Recorder started.")
        result(true);
    }
    
    fileprivate func stopRecording(_ result: @escaping FlutterResult) {
        RecordingManager.sharedInstance.stop();
        print("[\(TAG)] Recorder stopped.")
        result(true);
    }
    
}
