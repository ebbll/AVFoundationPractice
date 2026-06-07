//
//  AudioRecorder.swift
//  AVFoundationPractice
//
//  Created by 이은지 on 6/7/26.
//

import AVFoundation
import Combine

final class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    
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
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            print("녹음 시작: ", recordingUrl)
        } catch {
            print("녹음 시작 실패: ", error.localizedDescription)
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        print("녹음 정지")
    }
    
    func playRecording() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingUrl)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            print("녹음 파일 재생")
        } catch {
            print("녹음 파일 재생 실패: " ,error.localizedDescription)
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
