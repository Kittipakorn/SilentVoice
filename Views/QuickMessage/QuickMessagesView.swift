//
//  QuickMessagesView.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 4/2/2568 BE.
//

import SwiftUI

struct QuickMessagesView: View {
    
    @AppStorage("QMLanguage") private var QMLanguage: String = "en-US"
    private let ttsManager = TTSManager()
    @State private var showAddMessageSheet = false
    @State private var quickMessageModel = QuickMessageViewModel()
    @State private var showDeleteMessage = false
    @State private var deleteItem: QuickMessage = QuickMessage(id: UUID(), name: "", message: "")
    
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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Language")
                        .bold()
                    Spacer()
                    Picker("Language", selection: $QMLanguage) {
                        ForEach(languageNames.keys.sorted(), id: \.self) { code in
                            Text(languageNames[code] ?? "").tag(code)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()
                LazyVStack {
                    ForEach(quickMessageModel.quickMessages) { message in
                        HStack {
                            Button {
                                ttsManager.speak(text: message.message, lang: QMLanguage)
                            } label: {
                                HStack {
                                    Image(systemName: "play.fill")
                                        .padding(.horizontal, 15)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(message.name)
                                Text("'\(message.message)'")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button {
                                deleteItem = message
                                showDeleteMessage = true
                            } label: {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .padding(.horizontal, 15)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 10.0)
                        .foregroundColor(.primary)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(15)
                    }
                }
                .padding()
                Spacer()
            }
            .alert(isPresented: $showDeleteMessage) {
                Alert(
                    title: Text("Confirm Delete Message"),
                    message: Text("Are you sure you want to delete '\(deleteItem.name)'? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        quickMessageModel.deleteQuickMessage(id: deleteItem.id)
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear{
                quickMessageModel = QuickMessageViewModel()
            }
            .sheet(isPresented: $showAddMessageSheet, content: {
                AddMessageView()
                    .onDisappear{
                        quickMessageModel = QuickMessageViewModel()
                    }
            })
            .navigationTitle("Quick Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddMessageSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
