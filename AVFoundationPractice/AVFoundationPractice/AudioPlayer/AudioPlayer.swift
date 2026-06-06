//
//  AudioPlayer.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/4/26.
//

import AVFoundation
import Combine

final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isPlaying: Bool = false
    
    @Published var volume: Double = 1.0 {
        didSet {
            audioPlayer?.volume = Float(volume)
        }
    }
    
    @Published var isLooping: Bool = false {
        didSet {
            audioPlayer?.numberOfLoops = isLooping ? -1 : 0
        }
    }
    
    @Published var pan: Double = 0 {
        didSet {
            audioPlayer?.pan = Float(pan)
        }
    }
    
    @Published var rate: Double = 1.0 {
        didSet {
            audioPlayer?.rate = Float(rate)
        }
    }
    
    var currentTime: TimeInterval {
        audioPlayer?.currentTime ?? 0
    }
    
    var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    func loadSound(named fileName: String, extension fileExtension: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("파일을 찾을 수 없음", fileName, fileExtension)
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer?.delegate = self
            
            audioPlayer?.volume = Float(volume)
            audioPlayer?.numberOfLoops = isLooping ? -1 : 0
            audioPlayer?.pan = Float(pan)
            audioPlayer?.enableRate = true
            audioPlayer?.rate = Float(rate)
            audioPlayer?.isMeteringEnabled = true
            
            audioPlayer?.prepareToPlay()
            print("재생 준비 완료", fileName)
        } catch {
            print("재생 실패: ", error.localizedDescription)
        }
    }
    
    func play() {
        audioPlayer?.numberOfLoops = isLooping ? -1 : 0
        isPlaying = audioPlayer?.play() == true
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func updateMeters() {
        audioPlayer?.updateMeters()
    }
    
    func averagePower() -> Float {
        audioPlayer?.averagePower(forChannel: 0) ?? -160
    }
    
    func peakPower() -> Float {
        audioPlayer?.peakPower(forChannel: 0) ?? -160
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
