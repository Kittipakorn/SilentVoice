//
//  SoundAnalysis.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 14/1/2568 BE.
//

import SoundAnalysis
import CoreML
import Combine
import SwiftUI

protocol RealTimeSoundAnalyzerProtocol {
    var lastDetectedSound: String? { get }
    func startAnalysis()
    func stopAnalysis()
}

class RealTimeSoundAnalyzer: NSObject, ObservableObject, SNResultsObserving,RealTimeSoundAnalyzerProtocol {
    private var analyzer: SNAudioStreamAnalyzer!
    private var audioEngine = AVAudioEngine()
    private var sensitivity:Double = 0
    @Published var lastDetectedSound: String?
    @AppStorage("selectedSensitivity") private var selectedSensitivity: String = "Normal"
    private var SoundOptions = SoundOptionsViewModel()
    
    override init() {
        super.init()
        let audioFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        analyzer = SNAudioStreamAnalyzer(format: audioFormat)
    }
    
    func startLiveAudio() {
        audioEngine = AVAudioEngine()
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            try analyzer.add(request, withObserver: self)
            
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, time in
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            print("🎙️ Real-time sound analysis started.")
            
        } catch {
            print("❌ Error starting audio analysis: \(error.localizedDescription)")
        }
    }
    
    func startAnalysis() {
        stopAnalysis()
        SoundOptions = SoundOptionsViewModel()
        lastDetectedSound = nil
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            try analyzer.add(request, withObserver: self)
            
            let inputNode = audioEngine.inputNode
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, time in
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
            audioEngine.prepare()
            try audioEngine.start()
            print("Real-time analysis started.")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    func stopAnalysis() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        analyzer.removeAllRequests()
        print("Analysis stopped.")
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        if let result = result as? SNClassificationResult,
           let best = result.classifications.first {
            if selectedSensitivity == "Low" { sensitivity = 0.8 }
            else if selectedSensitivity == "Normal" { sensitivity = 0.65 }
            else { sensitivity = 0.5 }
            //            print("Detected sound: \(best.identifier), confidence: \(best.confidence) , sensitivity \(sensitivity)")
            if best.confidence >= sensitivity {
                var DetectedSound = best.identifier
                DetectedSound = DetectedSound.prefix(1).uppercased() + DetectedSound.dropFirst()
                DetectedSound = DetectedSound.replacingOccurrences(of: "_", with: " ")
                let option = SoundOptions.searchSoundOption(by: DetectedSound)
                if option?.isSelected == true {
                    lastDetectedSound = DetectedSound
                }
            }
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("Analysis completed.")
    }
}


class RealTimeSoundAnalyzerMock: RealTimeSoundAnalyzerProtocol {
    @Published var lastDetectedSound: String?
    private var soundOptions = SoundOptionsViewModel()
    private var timer: Timer?
    @AppStorage("selectedSensitivity") private var selectedSensitivity: String = "Normal"
    var sensitivity = 5

    func startAnalysis() {
        print("start mock analysis")
        soundOptions = SoundOptionsViewModel()
        
        if selectedSensitivity == "Low" { sensitivity = 8 }
        else if selectedSensitivity == "Normal" { sensitivity = 5 }
        else { sensitivity = 3 }
        
        timer = Timer.scheduledTimer(timeInterval: Double(sensitivity), target: self, selector: #selector(simulateDetection), userInfo: nil, repeats: true)
    }
    
    func stopAnalysis() {
        print("stop mock analysis")
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func simulateDetection() {
        let randomIdx = Int.random(in: 0..<soundOptions.soundOptions.count)
        if(soundOptions.soundOptions[randomIdx].isSelected) {
            lastDetectedSound = soundOptions.soundOptions[randomIdx].name
            print("Detected sound: \(lastDetectedSound ?? "No sound detected")")
        }
    }
}
