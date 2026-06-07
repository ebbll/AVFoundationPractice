//
//  RecordedAudioLabView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/7/26.
//

import SwiftUI
import Combine

struct RecordedAudioLabView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var audioEngine = AudioEngine()
    
    @State private var isLoadedIntoEngine = false
    
    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Recorded Audio Lab")
                    .font(.title2)
                
                // MARK: - Recording
                Button {
                    switch audioRecorder.isRecording {
                    case true:
                        audioRecorder.stopRecording()
                    case false:
                        audioEngine.stop()
                        isLoadedIntoEngine = false
                        audioRecorder.startRecording()
                    }
                } label: {
                    Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "record.circle")
                        .font(.largeTitle)
                        .foregroundStyle(audioRecorder.isRecording ? .red : .primary)
                }
                
                Text(formatTime(audioRecorder.recordingTime))
                    .font(.system(.title3, design: .monospaced))
                
                Text("Average: \(audioRecorder.averagePower, specifier: "%.1f") dB")
                ProgressView(value: normalizedPower(audioRecorder.averagePower))
                    .frame(width: 260)
                
                Text("Peak: \(audioRecorder.peakPower, specifier: "%.1f") dB")
                ProgressView(value: normalizedPower(audioRecorder.peakPower))
                    .frame(width: 260)
                
                Divider()
                
                // MARK: - Original Recording
                Text("Original Recording")
                
                HStack(spacing: 24) {
                    Button {
                        switch audioRecorder.isPlaying {
                        case true:
                            audioRecorder.stopPlaying()
                        case false:
                            audioRecorder.playRecording()
                        }
                    } label: {
                        Image(systemName: audioRecorder.isPlaying ? "stop.fill" : "play.fill")
                            .font(.largeTitle)
                    }
                    .disabled(!audioRecorder.hasRecording || audioRecorder.isRecording)
                    
                    Button {
                        audioRecorder.deleteRecording()
                        audioEngine.stop()
                        isLoadedIntoEngine = false
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.largeTitle)
                    }
                    .disabled(!audioRecorder.hasRecording || audioRecorder.isRecording)
                }
                
                Divider()
                
                // MARK: - Engine Playback
                Text("Engine Effects")
                
                Button {
                    audioRecorder.stopPlaying()
                    audioEngine.loadRecordedSound(url: audioRecorder.recordingUrl)
                    isLoadedIntoEngine = true
                } label: {
                    Image(systemName: "waveform.badge.plus")
                        .font(.largeTitle)
                }
                .disabled(!audioRecorder.hasRecording || audioRecorder.isRecording)
                
                Button {
                    switch audioEngine.isPlaying {
                    case true:
                        audioEngine.stop()
                    case false:
                        audioEngine.playRecordedSound()
                    }
                } label: {
                    Image(systemName: audioEngine.isPlaying ? "stop.fill" : "play.fill")
                        .font(.largeTitle)
                }
                .disabled(!isLoadedIntoEngine || audioRecorder.isRecording)
                
                Toggle("Loop", isOn: $audioEngine.isLooping)
                    .toggleStyle(.switch)
                    .frame(width: 260)
                
                Text("Pitch: \(Int(audioEngine.pitch)) cents")
                Slider(value: $audioEngine.pitch, in: -1200...1200)
                    .frame(width: 260)
                
                Text("Rate: \(String(format: "%.2f", audioEngine.playbackRate))x")
                Slider(value: $audioEngine.playbackRate, in: 0.5...2.0, step: 0.01)
                    .frame(width: 260)
                
                Text("Low Gain: \(Int(audioEngine.lowGain)) dB")
                Slider(value: $audioEngine.lowGain, in: -12...12)
                    .frame(width: 260)
                
                Text("Mid Gain: \(Int(audioEngine.midGain)) dB")
                Slider(value: $audioEngine.midGain, in: -12...12)
                    .frame(width: 260)
                
                Text("High Gain: \(Int(audioEngine.highGain)) dB")
                Slider(value: $audioEngine.highGain, in: -12...12)
                    .frame(width: 260)
                
                Toggle("Reverb On", isOn: $audioEngine.isReverbOn)
                    .toggleStyle(.switch)
                    .frame(width: 260)
                
                Text("Reverb Mix: \(Int(audioEngine.reverbWetDryMix))%")
                Slider(value: $audioEngine.reverbWetDryMix, in: 0...100)
                    .frame(width: 260)
                
                Toggle("Delay On", isOn: $audioEngine.isDelayOn)
                    .toggleStyle(.switch)
                    .frame(width: 260)
                
                Text("Delay Time: \(String(format: "%.2f", audioEngine.delayTime))")
                Slider(value: $audioEngine.delayTime, in: 0...2, step: 0.01)
                    .frame(width: 260)
                
                Text("Delay Feedback: \(Int(audioEngine.delayFeedback))%")
                Slider(value: $audioEngine.delayFeedback, in: 0...80)
                    .frame(width: 260)
                
                Text("Delay Mix: \(Int(audioEngine.delayWetDryMix))%")
                Slider(value: $audioEngine.delayWetDryMix, in: 0...100)
                    .frame(width: 260)
                
                Toggle("Distortion On", isOn: $audioEngine.isDistortionOn)
                    .toggleStyle(.switch)
                    .frame(width: 260)
                
                Text("Distortion Mix: \(Int(audioEngine.distortionWetDryMix))%")
                Slider(value: $audioEngine.distortionWetDryMix, in: 0...100)
                    .frame(width: 260)
            }
            .padding()
        }
        .onAppear {
            audioRecorder.checkRecordingFile()
        }
        .onReceive(timer) { _ in
            if audioRecorder.isRecording {
                audioRecorder.updateRecordingTime()
                audioRecorder.updateMeters()
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func normalizedPower(_ power: Float) -> Double {
        let minDb: Float = -60
        let maxDb: Float = 0
        
        let clampedPower = min(max(power, minDb), maxDb)
        
        return Double((clampedPower - minDb) / (maxDb - minDb))
    }
}
