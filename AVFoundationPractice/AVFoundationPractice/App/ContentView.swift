//
//  ContentView.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/3/26.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Text("AVFoundation 실험실")
                .font(.largeTitle)
            
            HStack {
//                AudioPlayerView()
                
//                AudioEngineView()
                
//                MicrophoneEngineView()
                
                RecordedAudioLabView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
