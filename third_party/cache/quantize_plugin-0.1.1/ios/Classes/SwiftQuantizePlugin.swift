import Flutter
import UIKit

public class SwiftQuantizePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "quantize_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftQuantizePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    guard let arg = (call.arguments as? NSDictionary) else { return }

    switch (call.method) {
        
    case "load_original":
        let srcW =  (arg["width"] as? Int)!
         let srcH =  (arg["height"] as? Int)!
         
         let bufferSize = srcH * srcW * 4
         let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
         let bytes = (arg["original"] as? FlutterStandardTypedData)!
         bytes.data.copyBytes(to: buffer, count: bufferSize)
        
        result(true)
         // buffer.append((arg["original"] as? FlutterStandardTypedData)! )
        
       /* srcW = (int) call.argument("width");
        srcH = (int) call.argument("height");
        qOriginal = ByteBuffer.allocateDirect(srcH * srcW * 4);
        qOriginal.put((byte[]) call.argument("original"));
        result.success(true);
       */
        break;
        
    case "quantize":
        //quantize(call, result);
        
        let width = (arg["width"] as? Int)!
        let height = (arg["height"] as? Int)!
        let quality = (arg["quality"] as? Int)!
        let dither = (arg["dither"] as? Bool)!
        let ditherLevel = (arg["ditherLevel"] as? Int)!
        let numColors = (arg["numColors"] as? Int)!
        let srcWidth = (arg["srcWidth"] as? Int)!
        let srcHeight = (arg["srcHeight"] as? Int)!
        

        var qp = QuantParams.init(width: width, height: height, quality: quality, dither: dither, ditherLevel: ditherLevel, numColors: numColors, srcWidth: srcWidth, srcHeight: srcHeight)
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform expensive task
            
            DispatchQueue.main.async {
                result()
                // Update the UI
            }
        }

        break;
        
    default:
        break;
    }
    }
}


    class QuantParams {
        
        init(width: Int, height: Int,quality:Int, dither:Bool, ditherLevel: Int,numColors: Int, srcWidth:Int, srcHeight:Int ) {
            // perform some initialization here
            self.width = width;
            self.height = height;
            self.quality = quality;
            self.dither = dither;
            self.ditherLevel = ditherLevel;
            self.numColors = numColors;
            self.srcWidth = srcWidth;
            self.srcHeight = srcHeight;
        }
        
        var width : Int;
        var height : Int;
        var quality :Int ;
        var dither : Bool;
        var ditherLevel :Int;
        var numColors :Int;
        var srcWidth: Int;
        var srcHeight : Int;
        
}



