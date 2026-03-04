//
//  SplashScreen.swift
//  SilentVoice
//
//  Created by Kittiapakorn Seenak on 3/2/2568 BE.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                VStack {
                    Image("SilentVoiceLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(20)
                        .foregroundColor(.yellow)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
