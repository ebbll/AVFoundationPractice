//
//  ContentView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDemo: Demo = .recordedAudioLab
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Text("AVFoundation 실험실")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 8) {
                    ForEach(Demo.allCases) { demo in
                        Button {
                            selectedDemo = demo
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: demo.systemImage)
                                    .font(.title3)
                                    .frame(width: 28)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(demo.title)
                                        .font(.headline)
                                    
                                    Text(demo.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(10)
                            .background(selectedDemo == demo ? Color.accentColor.opacity(0.15) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .frame(width: 280)
            .padding()
            .background(.thinMaterial)
            
            Divider()
            
            VStack(spacing: 16) {
                HStack {
                    Label(selectedDemo.title, systemImage: selectedDemo.systemImage)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                
                selectedDemoView
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 920, minHeight: 720)
    }
    
    @ViewBuilder
    private var selectedDemoView: some View {
        switch selectedDemo {
        case .audioPlayer:
            AudioPlayerView()
        case .audioEngine:
            AudioEngineView()
        case .microphoneEngine:
            MicrophoneEngineView()
        case .audioRecorder:
            AudioRecorderView()
        case .recordedAudioLab:
            RecordedAudioLabView()
        }
    }
}

private enum Demo: String, CaseIterable, Identifiable {
    case audioPlayer
    case audioEngine
    case microphoneEngine
    case audioRecorder
    case recordedAudioLab
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .audioPlayer:
            return "AudioPlayer"
        case .audioEngine:
            return "AudioEngine"
        case .microphoneEngine:
            return "Microphone Input"
        case .audioRecorder:
            return "AudioRecorder"
        case .recordedAudioLab:
            return "Recorded Audio Lab"
        }
    }
    
    var subtitle: String {
        switch self {
        case .audioPlayer:
            return "파일 재생 기초"
        case .audioEngine:
            return "노드와 이펙트 체인"
        case .microphoneEngine:
            return "실시간 마이크 입력"
        case .audioRecorder:
            return "녹음과 파일 관리"
        case .recordedAudioLab:
            return "녹음 파일 이펙트 실험"
        }
    }
    
    var systemImage: String {
        switch self {
        case .audioPlayer:
            return "play.circle"
        case .audioEngine:
            return "waveform.path.ecg"
        case .microphoneEngine:
            return "mic"
        case .audioRecorder:
            return "record.circle"
        case .recordedAudioLab:
            return "slider.horizontal.3"
        }
    }
}

#Preview {
    ContentView()
}
