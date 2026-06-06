//
//  AudioEngineView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/5/26.
//

import SwiftUI

struct AudioEngineView: View {
    @StateObject private var audioEnginePlayer = AudioEngine()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("AudioEngine")
            
            Button {
                switch audioEnginePlayer.isPlaying {
                case true:
                    audioEnginePlayer.stop()
                case false:
                    audioEnginePlayer.play()
                }
            } label: {
                Image(systemName: audioEnginePlayer.isPlaying ? "stop.fill" : "play.fill")
                    .font(.largeTitle)
            }
            
            // MARK: - Engine Volume
            Text("Engine Volume: \(Int(audioEnginePlayer.engineVolume * 100))%")
            Slider(value: $audioEnginePlayer.engineVolume, in: 0...1)
                .frame(width: 260)
            
            // MARK: - Loop
            Toggle("Loop", isOn: $audioEnginePlayer.isLooping)
                .toggleStyle(.switch)
                .frame(width: 260)
            
            // MARK: - First Node Volume
            Text("First Node Volume: \(Int(audioEnginePlayer.firstNodeVolume * 100))%")
            Slider(value: $audioEnginePlayer.firstNodeVolume, in: 0...1)
                .frame(width: 260)
            
            // MARK: - Second Node Volume
            Text("Second Node Volume: \(Int(audioEnginePlayer.secondNodeVolume * 100))%")
            Slider(value: $audioEnginePlayer.secondNodeVolume, in: 0...1)
                .frame(width: 260)
            
            // MARK: - First Node Pan
            Text("First Node Pan: \(audioEnginePlayer.firstNodePan)")
            Slider(value: $audioEnginePlayer.firstNodePan, in: -1...1, step: 0.01)
                .frame(width: 260)
            
            // MARK: - Second Node Pan
            Text("Second Node Pan: \(audioEnginePlayer.secondNodePan)")
            Slider(value: $audioEnginePlayer.secondNodePan, in: -1...1, step: 0.01)
                .frame(width: 260)
            
            // MARK: - Reverb Effect Node (wetDryMix)
            Text("Reverb Mix: \(Int(audioEnginePlayer.reverbWetDryMix))%")
            Slider(value: $audioEnginePlayer.reverbWetDryMix, in: 0...100)
                .frame(width: 260)
            
            // MARK: - Delay Effect Node (delayTime)
            Text("Delay Time: \(audioEnginePlayer.delayTime)")
            Slider(value: $audioEnginePlayer.delayTime, in: 0...2, step: 0.01)
                .frame(width: 260)

            // MARK: - Delay Effect Node (feedback)
            Text("Delay Feedback: \(Int(audioEnginePlayer.delayFeedback))%")
            Slider(value: $audioEnginePlayer.delayFeedback, in: 0...80)
                .frame(width: 260)

            // MARK: - Delay Effect Node (wetDryMix)
            Text("Delay Mix: \(Int(audioEnginePlayer.delayWetDryMix))%")
            Slider(value: $audioEnginePlayer.delayWetDryMix, in: 0...100)
                .frame(width: 260)
            
            // MARK: - Distortion Effect Node (wetDryMix)
            Text("Distortion Mix: \(Int(audioEnginePlayer.distortionWetDryMix))%")
            Slider(value: $audioEnginePlayer.distortionWetDryMix, in: 0...100)
                .frame(width: 260)
        }
        .onAppear {
            audioEnginePlayer.loadSound(first: "stars20", second: "stars20", extension: "wav")
        }
    }
}
