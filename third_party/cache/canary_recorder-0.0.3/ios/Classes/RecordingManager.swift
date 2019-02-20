//
//  RecordingManager.swift
//  canary_recorder
//
//  Created by Andrew Ackerman on 8/23/18.
//

import UIKit
import AVFoundation

class RecordingManager {
    
    let recordingSettings = [
        AVFormatIDKey: Int(kAudioFormatLinearPCM),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 1,
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsBigEndianKey: 0,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    var audioRecorder: AVAudioRecorder?
    var outputFile: URL?
    var isRecording = false
    
    static let sharedInstance = RecordingManager()
    private init () {}
    
    func prepare(filename: String) -> String {
        if isRecording {
            stop()
        }

        let pathSegments = filename.components(separatedBy: "/").filter { $0 != "" }
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var dir = docDir

        for segment in pathSegments {
            dir = docDir.appendingPathComponent(segment)
        }
        
        outputFile = dir
        return outputFile?.path ?? "<Invalid Path>"
    }
    
    func start() {
        guard let outputFile = outputFile else { return }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setActive(true)
            audioRecorder = try AVAudioRecorder(url: outputFile, settings: recordingSettings)
            audioRecorder?.record()
            
            isRecording = true
            print("Recording to file \(outputFile.absoluteString)")
        } catch {
            isRecording = false
            print("Error while attempting to record")
        }
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
    }
    
}
