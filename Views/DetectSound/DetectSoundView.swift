//
//  DetectSoundView.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 14/1/2568 BE.
//

import SwiftUI
import AVFoundation
import SoundAnalysis

struct DetectSoundView: View {
    @State private var isListening = false
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var detectedSounds: [DetectedSound] = []
    @State private var lastDetectionTime: Date? = nil
    @State private var lastDetectionSound: String = ""
    @State private var timer: Timer?
    @State private var showSettingsSheet = false
    @State private var showClearConfirmation = false
    private var SoundOptionsModel = SoundOptionsViewModel()
    @State private var detectedSoundsModel = DetectedSoundsViewModel()
    
    private let analyzer:RealTimeSoundAnalyzerProtocol

    init() {
//        #if targetEnvironment(simulator)
        self.analyzer = RealTimeSoundAnalyzerMock()
//        print("Running on Simulator")
//        #else
//        self.analyzer = RealTimeSoundAnalyzer()
//        #endif
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(isListening ? "Listening..." : "Paused")
                    .foregroundColor(isListening ? .green : .red)
                    .font(.headline)
                Spacer()
                
                Button (action: {
                    showClearConfirmation = true
                }){
                    Image(systemName: "trash.slash")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showClearConfirmation) {
                    Alert(
                        title: Text("Confirm Clear History"),
                        message: Text("Are you sure you want to clear all history? This action cannot be undone."),
                        primaryButton: .destructive(Text("Clear")) {
                            detectedSoundsModel.clearDetectedSounds()
                            detectedSounds = []
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Spacer()
                    Text("Recent Alerts🚨")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                
                ScrollView{
                    ForEach(detectedSounds) { sound in
                        HStack {
                            Text("\(sound.name)")
                                .font(.headline)
                            Spacer()
                            Text(DateFormatter.localizedString(from: sound.date, dateStyle: .none, timeStyle: .short))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: {
                    isListening.toggle()
                    if isListening {
                        analyzer.startAnalysis()
                        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                            DispatchQueue.main.async {
                                configureAnalyzer()
                            }
                        }
                    } else {
                        analyzer.stopAnalysis()
                        timer?.invalidate()
                        timer = nil
                    }
                }) {
                    Text(isListening ? "Stop Listening" : "Start Listening")
                        .font(.headline)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isListening ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showSettingsSheet, content: {
            SettingsView()
        })
        .navigationTitle("Detect Sound")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showSettingsSheet = true
                    analyzer.stopAnalysis()
                    isListening = false
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .onAppear{
            detectedSoundsModel = DetectedSoundsViewModel()
            detectedSounds = detectedSoundsModel.detectedSounds
        }
    }
    
    
    private func configureAnalyzer() {
        let currentTime = Date()
        if(analyzer.lastDetectedSound == nil) { return }
        if lastDetectionSound != analyzer.lastDetectedSound ||
            lastDetectionTime == nil ||
            currentTime.timeIntervalSince(lastDetectionTime ?? .distantPast) > 60 {
            lastDetectionTime = currentTime
            lastDetectionSound = analyzer.lastDetectedSound ?? ""
            let SoundOption = SoundOptionsModel.searchSoundOption(by: analyzer.lastDetectedSound ?? "")
            var DetectedSound = SoundOption?.name ?? ""
            DetectedSound = (SoundOption?.emoji ?? "❗️") + DetectedSound
            detectedSoundsModel.addDetectedSound(name: DetectedSound)
            detectedSounds = detectedSoundsModel.detectedSounds
            print("Sound added: \(analyzer.lastDetectedSound ?? "Unknown")")
        }
    }
}
