//
//  HelpView.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 4/2/2568 BE.
//
import SwiftUI

struct HelpView: View {
    @Binding var showHelp: Bool
    let helpImages = ["help1", "help2", "help3","help4"]
    let helpDescription = ["The app listens for environmental sounds and alerts you in real time. View recent sound detections and customize alerts in settings.", "Customize how the app listens to sounds by adjusting sensitivity levels and selecting specific sound filters. Tap 'Done' to save your preferences.", "Convert text to speech and speech to text for easy communication. Tap 'Speak' to read text aloud or 'Start Listening' to transcribe speech.","Access pre-saved phrases for quick conversations. Tap ▶️ to play a message or '+' to add new ones."]
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showHelp = false }) {
                            Text("Close")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text("📖 Help & Tutorial")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack{
                        Button(action: {
                            if currentIndex > 0 { currentIndex -= 1 }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(currentIndex > 0 ? .primary : .gray)
                        }
                        .disabled(currentIndex == 0)
                        
                        Spacer()
                        Image(helpImages[currentIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                        
                        Spacer()
                        Button(action: {
                            if currentIndex < helpImages.count - 1 { currentIndex += 1 }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .foregroundColor(currentIndex < helpImages.count - 1 ? .primary : .gray)
                        }
                        .disabled(currentIndex == helpImages.count - 1)
                    }
                    
                    Text(helpDescription[currentIndex])
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()
                    
                    VStack{
                        Text("Swift Student Challenge 2025")
                        Text("Kittipakorn Seenak")
                    }
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
                    .italic()
                    
                }
                .padding()
                .background(Color(.systemBackground).opacity(0.8))
                .cornerRadius(20)
                .shadow(radius: 10)
                .frame(width: (geometry.size.width*0.9 > 500 ? 500 : geometry.size.width*0.9))
            }
        }
    }
}
