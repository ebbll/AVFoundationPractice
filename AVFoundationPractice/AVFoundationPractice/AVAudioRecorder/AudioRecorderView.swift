//
//  AudioRecorderView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/7/26.
//

import SwiftUI

struct AudioRecorderView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    
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
        }
        .padding()
    }
}
