//
//  AudioPlayerView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/4/26.
//

import SwiftUI
import Combine

struct AudioPlayerView: View {
    @StateObject private var audioPlayer = AudioPlayer()
    
    @State private var currentTime: Double = 0
    
    @State private var averagePower: Float = -160
    @State private var peakPower: Float = -160
    
    // 드래그 중일 때 타이머가 값을 덮어쓰면 슬라이더가 버벅일 수 있으므로 이를 방지
    @State private var isDraggingProgress = false
    
    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Title
            Text("AudioPlayer")
            
            // MARK: - Controls
            HStack {
                Button {
                    switch audioPlayer.isPlaying {
                    case true:
                        audioPlayer.pause()
                    case false:
                        audioPlayer.play()
                    }
                } label: {
                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                }
                
                Button {
                    audioPlayer.stop()
                    currentTime = 0
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                }
            }
            
            VStack {
                // MARK: - Volume
                Text("Volume: \(Int(audioPlayer.volume * 100))%")
                Slider(value: $audioPlayer.volume, in: 0...1)
                
                // MARK: - Loop
                Toggle("Loop", isOn: $audioPlayer.isLooping)
                    .toggleStyle(.switch)
                
                // MARK: - Pan
                Text("Pan: \(audioPlayer.pan)")
                Slider(value: $audioPlayer.pan, in: -1...1, step: 0.01)
                
                // MARK: - Rate
                Text("Rate: \(audioPlayer.rate)")
                Slider(value: $audioPlayer.rate, in: 0.5...2.0, step: 0.01)
                
                // MARK: - Time Slider
                Text("\(formatTime(time: currentTime)) / \(formatTime(time: audioPlayer.duration))")
                    .font(.system(.body, design: .monospaced))
                Slider(
                    value: $currentTime,
                    in: 0...(audioPlayer.duration == 0 ? 1 : audioPlayer.duration),
                    onEditingChanged: { isEditing in
                        isDraggingProgress = isEditing
                        
                        if !isEditing {
                            audioPlayer.seek(to: currentTime)
                        }
                    }
                )
                
                // MARK: - Average Power
                Text("Avarage: \(averagePower, specifier: "%.1f") dB")
                ProgressView(value: normalizedPower(power: averagePower))
                    .frame(width: 260)
                
                // MARK: - Peak Power
                Text("Peak: \(peakPower, specifier: "%.1f") dB")
                ProgressView(value: normalizedPower(power: peakPower))
                    .frame(width: 260)
            }
            .frame(width: 260)
        }
        .padding()
        .onAppear() {
            audioPlayer.loadSound(named: "stars4", extension: "wav")
        }
        .onReceive(timer) { _ in
            if !isDraggingProgress {
                currentTime = audioPlayer.currentTime
            }
            
            audioPlayer.updateMeters()
            averagePower = audioPlayer.averagePower()
            peakPower = audioPlayer.peakPower()
        }
    }
    
    // MARK: - Time 값을 String으로 포맷팅하는 함수
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Power 값을 일반화하는 함수
    private func normalizedPower(power: Float) -> Double {
        let minDb: Float = -60
        let clamped = max(power, minDb)
        
        return Double((clamped - minDb) / -minDb)
    }
}
