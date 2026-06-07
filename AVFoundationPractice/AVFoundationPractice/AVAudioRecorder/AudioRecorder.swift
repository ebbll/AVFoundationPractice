//
//  AudioRecorder.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/7/26.
//

import AVFoundation
import Combine

final class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    // 레코더
    private var audioRecorder: AVAudioRecorder?
    
    // 플레이어
    private var audioPlayer: AVAudioPlayer?
    
    // 레코더 - 녹음 상태 관리
    @Published var isRecording: Bool = false
    @Published var hasRecording: Bool = false
    @Published var recordingTime: TimeInterval = 0
    
    // 플레이어 - 재생 상태 관리
    @Published var isPlaying: Bool = false
    
    // 녹음 중 소리 레벨 측정 미터링
    @Published var averagePower: Float = -160
    @Published var peakPower: Float = -160
    
    private var recordingUrl: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("practice-recording.m4a")
    }
    
    func startRecording() {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingUrl, settings: settings)
            
            audioRecorder?.delegate = self
            
            audioRecorder?.isMeteringEnabled = true
            
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            recordingTime = 0
            isRecording = true
            print("녹음 시작: ", recordingUrl)
        } catch {
            print("녹음 시작 실패: ", error.localizedDescription)
        }
    }
    
    func stopRecording() {
        // 레코더 정리
        audioRecorder?.stop()
        audioRecorder = nil
        
        // 상태값 정리
        isRecording = false
        hasRecording = FileManager.default.fileExists(atPath: recordingUrl.path)
        recordingTime = 0
        averagePower = -160
        peakPower = -160
        
        print("녹음 정지")
    }
    
    func playRecording() {
        guard hasRecording else {
            print("재생할 녹음 파일이 없음")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingUrl)
            
            audioPlayer?.delegate = self
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            print("녹음 파일 재생")
        } catch {
            print("녹음 파일 재생 실패: " ,error.localizedDescription)
        }
    }
    
    func deleteRecording() {
        stopPlaying()
        
        guard FileManager.default.fileExists(atPath: recordingUrl.path) else {
            hasRecording = false
            print("삭제할 녹음 파일이 없음")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: recordingUrl)
            hasRecording = false
            print("녹음 파일 삭제 완료")
        } catch {
            print("녹음 파일 삭제 실패: ", error.localizedDescription)
        }
    }
    
    func stopPlaying() {
        // 플레이어 정리
        audioPlayer?.stop()
        audioPlayer = nil
        
        // 상태값 정리
        isPlaying = false
        print("녹음 파일 정지")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("녹음 파일 재생 완료")
    }
    
    func updateRecordingTime() {
        recordingTime = audioRecorder?.currentTime ?? 0
    }
    
    func updateMeters() {
        audioRecorder?.updateMeters()
        averagePower = audioRecorder?.averagePower(forChannel: 0) ?? -160
        peakPower = audioRecorder?.peakPower(forChannel: 0) ?? -160
    }
}
