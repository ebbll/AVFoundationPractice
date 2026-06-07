//
//  MicrophoneEngine.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/7/26.
//

import AVFoundation
import Combine

final class MicrophoneEngine: ObservableObject {
    // 오디오 엔진
    private let audioEngine = AVAudioEngine()
    
    // 노드 연결 상태
    private var isGraphConnected = false
    
    // Effect 노드
    private let reverbEffectNode = AVAudioUnitReverb()
    
    @Published var isMonitoring = false
    
    @Published var reverbWetDryMix: Double = 40 {
        didSet {
            reverbEffectNode.wetDryMix = Float(reverbWetDryMix)
        }
    }
    
    func startMonitoring() {
        if !isGraphConnected {
            let inputNode = audioEngine.inputNode
            let inputFormat = inputNode.outputFormat(forBus: 0)
            
            audioEngine.attach(reverbEffectNode)
            
            audioEngine.connect(inputNode, to: reverbEffectNode, format: inputFormat)
            audioEngine.connect(reverbEffectNode, to: audioEngine.mainMixerNode, format: inputFormat)
            
            reverbEffectNode.loadFactoryPreset(.largeHall)
            reverbEffectNode.wetDryMix = Float(reverbWetDryMix)
            
            isGraphConnected = true
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            isMonitoring = true
            print("마이크 모니터링 시작")
        } catch {
            print("마이크 입력 시작 실패: ", error.localizedDescription)
        }
    }
    
    func stopMonitoring() {
        audioEngine.stop()
        isMonitoring = false
        print("마이크 모니터링 정지")
    }
}
