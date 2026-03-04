//
//  DetectedHistory.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 20/1/2568 BE.
//

import Foundation

struct DetectedSound: Codable, Identifiable {
    var id = UUID()
    var name: String
    var date: Date
}

class DetectedSoundsViewModel: ObservableObject {
    @Published var detectedSounds: [DetectedSound] = []

    private let userDefaultsKey = "detectedSounds"

    init() {
        loadDetectedSounds()
    }

    func saveDetectedSounds() {
        if let encodedData = try? JSONEncoder().encode(detectedSounds) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } else {
            print("Failed to encode detectedSounds")
        }
    }

    func loadDetectedSounds() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedData = try? JSONDecoder().decode([DetectedSound].self, from: savedData) {
            detectedSounds = decodedData
        } else {
            detectedSounds = []
        }
    }

    
    func addDetectedSound(name: String) {
        let newSound = DetectedSound(id: UUID(), name: name, date: Date())
        detectedSounds.insert(newSound, at: 0)
        saveDetectedSounds()
    }

    func clearDetectedSounds() {
        detectedSounds = []
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
