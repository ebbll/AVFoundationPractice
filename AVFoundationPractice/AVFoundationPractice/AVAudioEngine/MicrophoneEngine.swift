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
    
    // 마이크 입력 포맷을 효과 노드가 받기 좋은 포맷으로 넘겨주는 중간 믹서
    private let microphoneMixerNode = AVAudioMixerNode()
    
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
            
            print("Input Format: ", inputFormat)
            
            guard inputFormat.sampleRate > 0, inputFormat.channelCount > 0 else {
                print("마이크 입력 포맷을 가져오지 못함")
                return
            }
            
            guard let effectFormat = AVAudioFormat(standardFormatWithSampleRate: inputFormat.sampleRate, channels: 2) else {
                print("마이크 포맷 생성 실패")
                return
            }
            
            audioEngine.attach(microphoneMixerNode)
            audioEngine.attach(reverbEffectNode)
            
            audioEngine.connect(inputNode, to: microphoneMixerNode, format: inputFormat)
            audioEngine.connect(microphoneMixerNode, to: reverbEffectNode, format: effectFormat)
            audioEngine.connect(reverbEffectNode, to: audioEngine.mainMixerNode, format: effectFormat)
            
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
