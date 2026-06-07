//
//  MicrophoneEngineView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/7/26.
//

import SwiftUI

struct MicrophoneEngineView: View {
    @StateObject private var microphoneEngine = MicrophoneEngine()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Microphone Input")
            
            Button {
                switch microphoneEngine.isMonitoring {
                case true:
                    microphoneEngine.stopMonitoring()
                case false:
                    microphoneEngine.startMonitoring()
                }
            } label: {
                Image(systemName: microphoneEngine.isMonitoring ? "stop.fill" : "mic.fill")
                    .font(.largeTitle)
            }
            
            // MARK: - Reverb Effect
            Text("Reverb Mix: \(Int(microphoneEngine.reverbWetDryMix))%")
            Slider(value: $microphoneEngine.reverbWetDryMix, in: 0...100)
                .frame(width: 260)
        }
        .padding()
    }
}
