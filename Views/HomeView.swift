//
//  HomeView.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 14/1/2568 BE.
//

import SwiftUI

struct HomeView: View {
    @State private var showHelp = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                GeometryReader { geometry in
                    VStack(spacing: 20){
                        VStack(spacing: 10){
                            HStack {
                                Text("Welcome to SilentVoice")
                                    .font(.system(size: 20))
                                    .bold()
                                Spacer()
                                Button {
                                    showHelp = true
                                } label: {
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 25))
                                        .foregroundColor(.blue)
                                }
                            }
                            Text("Explore your world through sound.📣")
                                .font(.system(size: geometry.size.height*0.04))
                                .bold()
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        VStack(spacing: geometry.size.width * 0.05) {
                            NavigationLink(destination: DetectSoundView()) {
                                VStack {
                                    Image(systemName: "waveform")
                                        .font(.system(size: 80))
                                        .padding(.bottom, 10)
                                    
                                    Text("Detect Sound")
                                        .font(.system(size: 20))
                                        .font(.title)
                                        .bold()
                                }
                                .frame(width: geometry.size.width * 0.98, height: geometry.size.height * 0.42)
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                            }
                            
                            HStack(spacing: geometry.size.width * 0.05) {
                                NavigationLink(destination: TalkingView()) {
                                    VStack {
                                        Image(systemName: "mic.fill")
                                            .font(.system(size: 60))
                                            .padding(.bottom, 10)
                                        
                                        Text("Speak & Listen")
                                            .font(.system(size: 17))
                                            .font(.title)
                                            .bold()
                                    }
                                    .frame(width: geometry.size.width * 0.47, height: geometry.size.height * 0.32)
                                    .background(Color.purple.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 5)
                                }
                                
                                NavigationLink(destination: QuickMessagesView()) {
                                    VStack {
                                        Image(systemName: "bubble.left.and.text.bubble.right.fill")
                                            .font(.system(size: 60))
                                            .padding(.bottom, 10)
                                        
                                        Text("Quick Messages")
                                            .font(.system(size: 17))
                                            .font(.title)
                                            .bold()
                                    }
                                    .frame(width: geometry.size.width * 0.47, height: geometry.size.height * 0.32)
                                    .background(Color.cyan.opacity(0.8))
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .padding()
                .blur(radius: showHelp ? 20 : 0)
                if showHelp {
                    HelpView(showHelp: $showHelp)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: showHelp)
        }
    }
}
