//
//  configureAudioSession.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 14/1/2568 BE.
//

import AVFoundation

func configureAudioSession(for mode: AVAudioSession.Mode) {
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(.playAndRecord, mode: mode, options: [.mixWithOthers, .defaultToSpeaker])
        try session.setActive(true)
        print("Audio session configured for mode: \(mode)")
    } catch {
        print("Failed to configure audio session: \(error)")
    }
}
