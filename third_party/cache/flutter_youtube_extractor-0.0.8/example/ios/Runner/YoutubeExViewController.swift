//
//  YoutubeExViewController.swift
//  Runner
//
//  Created by Trong Ton on 10/8/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import UIKit
//import XCDYouTubeKit

class YoutubeExViewController: FlutterViewController {
    var extractChannel: FlutterMethodChannel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        extractChannel = FlutterMethodChannel.init(name: "flutter.youtube.extractor/native", binaryMessenger: self)
        extractChannel.setMethodCallHandler { (call, result) in
            let params = call.arguments as? String
            switch call.method {
                case "getYoutubeMediaLink":
                    self.getLinkVideoFromYoutube(params!)
                    break
                default:
                    break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
//        extractChannel.invokeMethod("receiveYoutubeMediaLink", arguments: "www.google.com")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension YoutubeExViewController {
    struct YouTubeVideoQuality {
        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
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
//                        print(directLink.absoluteString)
                        DispatchQueue.main.async {
                            self.extractChannel.invokeMethod("receiveYoutubeMediaLink", arguments: directLink.absoluteString)
                        }
                    }
                } else {
                    error?.localizedDescription
                }
            } else {
                print("error with: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
