//
//  QuickMessage.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 4/2/2568 BE.
//

import Foundation

struct QuickMessage: Codable, Identifiable {
    var id = UUID()
    var name: String
    var message: String
}

class QuickMessageViewModel: ObservableObject {
    @Published var quickMessages: [QuickMessage] = []
    
    private let userDefaultsKey = "quickMessages"
    
    init() {
        loadQuickMessages()
    }
    
    func saveQuickMessages() {
        if let encodedData = try? JSONEncoder().encode(quickMessages) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } else {
            print("Failed to encode detectedSounds")
        }
    }
    
    func loadQuickMessages() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedData = try? JSONDecoder().decode([QuickMessage].self, from: savedData) {
            quickMessages = decodedData
        } else {
            quickMessages = []
        }
    }
    
    func addQuickMessages(name: String, message: String) {
        let newMessage = QuickMessage(name: name, message: message)
        quickMessages.append(newMessage)
        saveQuickMessages()
    }
    
    func deleteQuickMessage(id: UUID) {
        quickMessages.removeAll(where: { $0.id == id })
        saveQuickMessages()
    }
}
