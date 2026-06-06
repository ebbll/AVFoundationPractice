//
//  AudioEngine.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/4/26.
//

import AVFoundation
import Combine

final class AudioEngine: ObservableObject {
    // 오디오 엔진
    private let audioEngine = AVAudioEngine()
    
    // 오디오 파일
    private var firstAudioFile: AVAudioFile?
    private var secondAudioFile: AVAudioFile?
    
    // 오디오 버퍼 (loop 옵션을 위해)
    private var firstAudioBuffer: AVAudioPCMBuffer?
    private var secondAudioBuffer: AVAudioPCMBuffer?
    
    // Player 노드
    private let firstPlayerNode = AVAudioPlayerNode()
    private let secondPlayerNode = AVAudioPlayerNode()
    
    
    // Effect 노드
    private let reverbEffectNode = AVAudioUnitReverb()
    private let delayEffectNode = AVAudioUnitDelay()
    private let distortionEffectNode = AVAudioUnitDistortion()
    
    // 노드 사이 연결
    private var isGraphConnected = false
    
    @Published var isPlaying: Bool = false
    
    @Published var isLooping: Bool = false
    
    // 엔진 전체 볼륨
    @Published var engineVolume: Double = 1.0 {
        didSet {
            audioEngine.mainMixerNode.outputVolume = Float(engineVolume)
        }
    }
    
    // 각 노드 볼륨
    @Published var firstNodeVolume: Double = 1.0 {
        didSet {
            firstPlayerNode.volume = Float(firstNodeVolume)
        }
    }
    @Published var secondNodeVolume: Double = 1.0 {
        didSet {
            secondPlayerNode.volume = Float(secondNodeVolume)
        }
    }
    
    // 노드 팬
    @Published var firstNodePan: Double = -0.4 {
        didSet {
            firstPlayerNode.pan = Float(firstNodePan)
        }
    }
    @Published var secondNodePan: Double = 0.4 {
        didSet {
            secondPlayerNode.pan = Float(secondNodePan)
        }
    }
    
    // reverb 효과
    @Published var reverbWetDryMix: Double = 40 {
        didSet {
            reverbEffectNode.wetDryMix = Float(reverbWetDryMix)
        }
    }
    
    // delay 효과
    @Published var delayTime: Double = 0.3 {
        didSet {
            delayEffectNode.delayTime = delayTime
        }
    }
    @Published var delayFeedback: Double = 30 {
        didSet {
            delayEffectNode.feedback = Float(delayFeedback)
        }
    }
    @Published var delayWetDryMix: Double = 40 {
        didSet {
            delayEffectNode.wetDryMix = Float(delayWetDryMix)
        }
    }
    
    // distortion 효과
    @Published var distortionWetDryMix: Double = 0 {
        didSet {
            distortionEffectNode.wetDryMix = Float(distortionWetDryMix)
        }
    }
    
    func loadSound(first firstName: String, second secondName: String, extension fileExtension: String) {
        // 파일 url
        guard let firstUrl = Bundle.main.url(forResource: firstName, withExtension: fileExtension), let secondUrl = Bundle.main.url(forResource: secondName, withExtension: fileExtension) else {
            print("파일을 찾을 수 없음")
            return
        }
        
        do {
            // 파일 읽기
            let firstFile = try AVAudioFile(forReading: firstUrl)
            let secondFile = try AVAudioFile(forReading: secondUrl)
            
            firstAudioFile = firstFile
            secondAudioFile = secondFile
            
            // 버퍼 만들기 (loop 설정)
            guard let firstBuffer = AVAudioPCMBuffer(pcmFormat: firstFile.processingFormat, frameCapacity: AVAudioFrameCount(firstFile.length)), let secondBuffer = AVAudioPCMBuffer(pcmFormat: secondFile.processingFormat, frameCapacity: AVAudioFrameCount(secondFile.length)) else {
                print("버퍼 생성 실패")
                return
            }
            
            try firstFile.read(into: firstBuffer)
            try secondFile.read(into: secondBuffer)
            
            firstAudioBuffer = firstBuffer
            secondAudioBuffer = secondBuffer
            
            // 연결
            if !isGraphConnected {
                audioEngine.attach(firstPlayerNode)
                audioEngine.attach(secondPlayerNode)
                audioEngine.attach(reverbEffectNode)
                audioEngine.attach(delayEffectNode)
                audioEngine.attach(distortionEffectNode)
                
                audioEngine.connect(firstPlayerNode, to: audioEngine.mainMixerNode, format: firstFile.processingFormat)
                audioEngine.connect(secondPlayerNode, to: reverbEffectNode, format: secondFile.processingFormat)
                audioEngine.connect(reverbEffectNode, to: delayEffectNode, format: secondFile.processingFormat)
                audioEngine.connect(delayEffectNode, to: distortionEffectNode, format: secondFile.processingFormat)
                audioEngine.connect(distortionEffectNode, to: audioEngine.mainMixerNode, format: secondFile.processingFormat)
                
                isGraphConnected = true
            }
            
            // 엔진 전체 볼륨
            audioEngine.mainMixerNode.outputVolume = Float(engineVolume)
            
            // 각 노드 볼륨
            firstPlayerNode.volume = Float(firstNodeVolume)
            secondPlayerNode.volume = Float(secondNodeVolume)
            
            // 노드 팬
            firstPlayerNode.pan = Float(firstNodePan)
            secondPlayerNode.pan = Float(secondNodePan)
            
            // reverb 이펙트
            reverbEffectNode.loadFactoryPreset(.largeHall)
            reverbEffectNode.wetDryMix = Float(reverbWetDryMix)
            
            // delay 이펙트
            delayEffectNode.delayTime = delayTime
            delayEffectNode.feedback = Float(delayFeedback)
            delayEffectNode.wetDryMix = Float(delayWetDryMix)
            
            // distortion 이펙트
            distortionEffectNode.loadFactoryPreset(.drumsLoFi)
            distortionEffectNode.wetDryMix = Float(distortionWetDryMix)
            
            audioEngine.prepare()
            try audioEngine.start()
            print("엔진 준비 완료: ")
        } catch {
            print("엔진 로드 실패: ", error.localizedDescription)
        }
    }
    
    func play() {
        guard let firstAudioBuffer, let secondAudioBuffer else { return }
        
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
            } catch {
                print("엔진 시작 실패: ", error.localizedDescription)
                return
            }
        }
        
        firstPlayerNode.stop()
        secondPlayerNode.stop()
        
        let loopOption: AVAudioPlayerNodeBufferOptions = isLooping ? .loops : []
        
        firstPlayerNode.scheduleBuffer(firstAudioBuffer, at: nil, options: loopOption)
        secondPlayerNode.scheduleBuffer(secondAudioBuffer, at: nil, options: loopOption) {  [weak self] in
            DispatchQueue.main.async {
                self?.isPlaying = false
            }
        }
        
        firstPlayerNode.play()
        secondPlayerNode.play()
        
        isPlaying = true
    }
    
    func stop() {
        firstPlayerNode.stop()
        secondPlayerNode.stop()
        
        isPlaying = false
    }
}
