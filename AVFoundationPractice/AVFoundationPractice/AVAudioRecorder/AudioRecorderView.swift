//
//  AudioRecorderView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/7/26.
//

import SwiftUI
import Combine

struct AudioRecorderView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    
    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Audio Recorder")
            
            Button {
                switch audioRecorder.isRecording {
                case true:
                    audioRecorder.stopRecording()
                case false:
                    audioRecorder.startRecording()
                }
            } label: {
                Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "record.circle")
                    .font(.largeTitle)
                    .foregroundStyle(audioRecorder.isRecording ? .red : .primary)
            }
            
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
            
            // MARK: - 녹음 타이머
            Text(formatTime(audioRecorder.recordingTime))
                .font(.system(.title3, design: .monospaced))
            
            // MARK: - 녹음 미터기
            Text("Average: \(audioRecorder.averagePower, specifier: "%.1f") dB")
            ProgressView(value: audioRecorder.averagePower)
                .frame(width: 260)
            
            Text("Peak: \(audioRecorder.averagePower, specifier: "%.1f") dB")
            ProgressView(value: audioRecorder.peakPower)
                .frame(width: 260)
        }
        .onReceive(timer) { _ in
            if audioRecorder.isRecording {
                audioRecorder.updateRecoringTime()
                audioRecorder.updateMeters()
            }
        }
        .padding()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
