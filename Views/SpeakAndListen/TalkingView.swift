import SwiftUI
import Speech
import AVFoundation

struct TalkingView: View {
    @StateObject private var speechRecognizer = SpeechToTextManager()
    @State private var isListening = false
    @State private var textToSpeak: String = ""
    @State private var isSpeaking = false
    @FocusState private var isTextFieldFocused: Bool
    private let ttsManager = TTSManager()
    
    @State private var transcription: String = ""

    @AppStorage("TTSlanguage") private var TTSlanguage: String = "en-US"
    @AppStorage("STTlanguage") private var STTlanguage: String = "en-US"
    
    let languageNames = [
        "en-US": "English",
        "zh-CN": "Chinese",
        "es-ES": "Spanish",
        "fr-FR": "French",
        "de-DE": "German",
        "ja-JP": "Japanese",
        "ru-RU": "Russian",
        "th-TH": "Thai"
    ]
    
    @State private var selectedSensitivity = "Normal"
    
    var body: some View {
        VStack(spacing: 20) {
            
            ScrollView{
                VStack(alignment: .leading, spacing: 15) {
                    HStack{
                        Text("🗣️Speak")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        Picker("TTSLanguage", selection: $TTSlanguage) {
                            ForEach(languageNames.keys.sorted(), id: \.self) { code in
                                Text(languageNames[code] ?? "").tag(code)
                            }
                        }
                    }
                    
                    TextField("Enter text here...", text: $textToSpeak)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            isTextFieldFocused = false
                        }
                    
                    Button(action: {
                        print(TTSlanguage)
                        isSpeaking = true
                        ttsManager.speak(text: textToSpeak,lang: TTSlanguage) {
                            isSpeaking = false
                            textToSpeak = ""
                        }
                    }) {
                        Text(isSpeaking ? "Speaking..." : "Speak")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isSpeaking ? Color.orange : Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                
                Divider()
                    .padding(.vertical, 20)
                
                // Speech-to-Text Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack{
                        Text("👂Listen")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        Picker("STTLanguage", selection: $STTlanguage) {
                            ForEach(languageNames.keys.sorted(), id: \.self) { code in
                                Text(languageNames[code] ?? "").tag(code)
                            }
                        }
                    }
                    Text(transcription == "" ? speechRecognizer.transcription : transcription)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, minHeight: 130, alignment: .topLeading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
                        isListening.toggle()
                        if isListening {
                            speechRecognizer.startListening()
                            transcription = ""
                        } else {
                            transcription = speechRecognizer.transcription
                            speechRecognizer.stopListening()
                        }
                    }) {
                        Text(isListening ? "Stop Listening" : "Start Listening")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isListening ? Color.red : Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
        .navigationTitle("Speak & Listen")
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack{
                    Spacer()
                    Button("Done") {
                        isTextFieldFocused = false
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
