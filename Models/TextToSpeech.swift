//
//  TextToSpeech.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 14/1/2568 BE.
//

import UIKit
import AVFoundation
import SwiftUI

class TTSManager: NSObject, @unchecked Sendable {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var completion: (() -> Void)?
    
    func speak(text: String,lang: String, completion: (() -> Void)? = nil) {
        guard !text.isEmpty else {
            print("Text is empty. Please provide something to speak.")
            completion?()
            return
        }
        
        self.completion = completion
        
        configureAudioSession(for: .spokenAudio)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        utterance.rate = 0.5
        
        print("Speaking: \(text)")
        speechSynthesizer.delegate = self
        speechSynthesizer.speak(utterance)
    }
}

extension TTSManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Finished speaking: \(utterance.speechString)")
        completion?()
    }
}
