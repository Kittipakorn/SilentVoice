//
//  AddMessage.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 4/2/2568 BE.
//

import SwiftUI

struct AddMessageView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var message: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var quickMessageModel = QuickMessageViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .focused($isTextFieldFocused)
                    
                    ZStack(alignment: .topLeading) {
                        if message.isEmpty {
                            Text("Enter your message here...")
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.leading , 20)
                                .padding(.top , 25)
                        }
                        
                        TextEditor(text: $message)
                            .frame(height: 150)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .focused($isTextFieldFocused)
                    }
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }.foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if(!message.isEmpty && !name.isEmpty){
                            quickMessageModel.addQuickMessages(name: name, message: message)
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Spacer()
                        Button("Done") {
                            isTextFieldFocused = false
                        }
                    }
                }
            }
        }
    }
}
