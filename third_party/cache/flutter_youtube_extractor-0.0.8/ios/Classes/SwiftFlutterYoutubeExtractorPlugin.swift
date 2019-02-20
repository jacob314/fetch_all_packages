import Flutter
import UIKit
import XCDYouTubeKit

struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

var channel: FlutterMethodChannel!

public class SwiftFlutterYoutubeExtractorPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "flutter.youtube.extractor/native", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterYoutubeExtractorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getYoutubeMediaLink":
            self.getLinkVideoFromYoutube(call.arguments as! String)
            break

        case "requestRotateScreen":
            requestRotateScreen(call.arguments as! Bool)
            break

        default:
            break
        }
    }

    func extractYouTubeId(from url: String) -> String? {
        let typePattern = "(?:(?:\\.be\\/|embed\\/|v\\/|\\?v=|\\&v=|\\/videos\\/)|(?:[\\w+]+#\\w\\/\\w(?:\\/[\\w]+)?\\/\\w\\/))([\\w-_]+)"
        let regex = try? NSRegularExpression(pattern: typePattern, options: .caseInsensitive)
        return regex
            .flatMap { $0.firstMatch(in: url, range: NSMakeRange(0, url.count)) }
            .flatMap { Range($0.range(at: 1), in: url) }
            .map { String(url[$0]) }
    }

    func getLinkVideoFromYoutube(_ url: String) {
        let videoIdentifier = extractYouTubeId(from: url)
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { (videos, error) in
            if videos != nil {
                if let video = videos {
                    if let directLink = video.streamURLs[YouTubeVideoQuality.hd720] ?? video.streamURLs[YouTubeVideoQuality.medium360] ?? video.streamURLs[YouTubeVideoQuality.small240] {
                        DispatchQueue.main.async {
                            channel.invokeMethod("receiveYoutubeMediaLink", arguments: directLink.absoluteString)
                        }
                    }
                }
            } else {
                print("error with: \(String(describing: error?.localizedDescription))")
            }
        }
    }

    func requestRotateScreen(_ isLandscape: Bool) {
        var orientation = UIInterfaceOrientation.portrait.rawValue

        if(isLandscape) {
            orientation = UIInterfaceOrientation.landscapeLeft.rawValue
        }

        UIDevice.current.setValue(orientation, forKey: "orientation")
    }
}
