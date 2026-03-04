import SwiftUI
import Speech

class SpeechToTextManager: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @AppStorage("STTlanguage") private var STTlanguage: String = "en-US"
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    @Published var transcription: String = "Press Start to begin listening..."
    @Published var isListening: Bool = false
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized")
                    
                case .denied:
                    print("User denied access to speech recognition")
                case .restricted:
                    print("Speech recognition restricted on this device")
                case .notDetermined:
                    print("Speech recognition not yet authorized")
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        }
    }
    
    
    func startListening() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: STTlanguage))
        
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            self.transcription = "❌ Speech recognizer not available."
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            recognitionRequest?.shouldReportPartialResults = true
            
            recognitionTask = recognizer.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
                guard let self = self else { return }
                
                if let result = result {
                    self.transcription = result.bestTranscription.formattedString
                }
                
                if let error = error {
                    print("❌ Recognition error: \(error.localizedDescription)")
                    self.stopListening()
                }
            }
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            self.isListening = true
            self.transcription = "Listening... Speak now!"
        } catch {
            self.transcription = "❌ Failed to start listening: \(error.localizedDescription)"
            stopListening()
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        configureAudioSession(for: .spokenAudio)
        
        self.isListening = false
    }
}
