//
//  Settings.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 15/1/2568 BE.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isSoundEnabled: Bool = true
    @State private var SoundOptions = SoundOptionsViewModel()
    @State var boolSoundOptions: [Bool] = []
    @AppStorage("selectedSensitivity") private var selectedSensitivity: String = "Normal"
    @State private var displayCount = 0
    
    let Sensitivity = ["Low", "Normal", "High"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sensitivity")) {
                    Picker("Sensitivity", selection: $selectedSensitivity) {
                        ForEach(Sensitivity, id: \.self) { sensitive in
                            Text(sensitive).tag(sensitive)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: HStack {
                    Text("Filters")
                    Spacer()
                    Button("Select All") {
                        SoundOptions.selectAll()
                        boolSoundOptions = SoundOptions.soundOptions.map { $0.isSelected }
                    }
                    .foregroundColor(.blue)
                    .textCase(.none)
                }) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            let displayedOptions = Array(boolSoundOptions.prefix(displayCount).enumerated())
                            ForEach(displayedOptions, id: \.0) { index,option in
                                Button(action: {
                                    SoundOptions.toggleSelection(for: SoundOptions.soundOptions[index])
                                    boolSoundOptions[index].toggle()
                                }) {
                                    HStack {
                                        Image(systemName: option ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(option ? .blue : .gray)
                                            .font(.system(size: 20))
                                        Text(SoundOptions.soundOptions[index].emoji)
                                            .font(.system(size: 20))
                                        Text(SoundOptions.soundOptions[index].name)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                .padding(.vertical)
                                Divider()
                            }
                            if displayCount < SoundOptions.soundOptions.count {
                                ProgressView()
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            displayCount += 303
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            boolSoundOptions = SoundOptions.soundOptions.map { $0.isSelected }
        }
    }
}
