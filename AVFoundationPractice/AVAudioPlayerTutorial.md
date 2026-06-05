# AVAudioPlayer Tutorial

## 목표

`AVAudioPlayer`만 사용해서 파일 하나를 안정적으로 재생하고, 기본 재생 제어 기능을 하나씩 실습한다.

## 현재 실습 범위

- 파일 재생
- 재생, 일시정지, 정지
- 처음으로 되감기
- 볼륨 조절
- 반복 재생
- 좌우 팬 조절
- 재생 속도 조절
- 재생 시간 표시와 진행 바

## 목차

### 1. 프로젝트 준비

- 새 SwiftUI macOS 프로젝트 만들기
- `stars.wav` 파일 추가하기
- Target Membership 확인하기
- `Bundle.main.url(forResource:withExtension:)`로 파일 찾기

### 2. AVFoundation 연결

- `import AVFoundation`
- `AVAudioPlayer` 인스턴스 만들기
- `AVAudioPlayer(contentsOf:)` 이해하기

### 3. AudioPlayer 클래스 만들기

- `AudioPlayer` 파일 생성
- `ObservableObject` 적용
- `private var audioPlayer: AVAudioPlayer?`로 플레이어 보관
- `loadSound(named:extension:)` 만들기

### 4. 오디오 파일 준비

- `prepareToPlay()` 실습
- 파일 로드 실패 처리
- 콘솔 로그로 로드 상태 확인

### 5. 기본 재생 제어

- `play()` 실습
- `pause()` 실습
- `stop()` 실습
- `currentTime = 0`으로 처음 위치로 되감기

### 6. SwiftUI View와 연결

- `AudioPlayerView` 만들기
- `@StateObject private var audioPlayer = AudioPlayer()`
- Play/Pause 버튼 만들기
- Stop 버튼 만들기
- `onAppear`에서 `loadSound` 호출하기

### 7. 볼륨 조절

- `AVAudioPlayer.volume`
- `@Published var volume`
- `Slider(value: $audioPlayer.volume, in: 0...1)`
- 볼륨 퍼센트 텍스트 표시

### 8. 반복 재생

- `AVAudioPlayer.numberOfLoops`
- `0`, `1`, `-1`의 의미
- `@Published var isLooping`
- `Toggle("Loop", isOn: $audioPlayer.isLooping)`
- 상태를 View가 아니라 `AudioPlayer`가 소유하도록 정리

### 9. 좌우 팬 조절

- `AVAudioPlayer.pan`
- `-1.0`, `0.0`, `1.0`의 의미
- `@Published var pan`
- Pan 슬라이더 만들기
- Left, Center, Right 텍스트 표시

### 10. 재생 속도 조절

- `AVAudioPlayer.enableRate`
- `AVAudioPlayer.rate`
- `@Published var rate`
- `Slider(value: $audioPlayer.rate, in: 0.5...2.0)`
- 속도와 피치가 함께 변하는 특성 확인

### 11. 현재 시간과 전체 길이 표시

- `AVAudioPlayer.currentTime`
- `AVAudioPlayer.duration`
- 재생 시간 텍스트 표시
- `Timer.publish`로 주기적으로 현재 시간 읽기

### 12. 진행 바와 구간 이동

- `currentTime`을 Slider와 연결
- 원하는 초 위치로 이동하기
- Stop 후 처음으로 돌아가는 동작 확인

### 13. 재생 완료 감지

- `AVAudioPlayerDelegate`
- `audioPlayerDidFinishPlaying`
- 곡이 끝났을 때 `isPlaying` 상태 정리

### 14. 음량 미터링

- `isMeteringEnabled`
- `updateMeters()`
- `averagePower(forChannel:)`
- 간단한 레벨 미터 만들기

### 15. 마무리 점검

- 재생, 일시정지, 정지가 자연스럽게 동작하는지 확인
- Loop, Volume, Pan, Rate가 재생 전/재생 중 모두 반영되는지 확인
- View 상태와 AudioPlayer 상태가 중복되지 않는지 확인
- 다음 단계로 `AVAudioEngine`을 배울 준비가 되었는지 확인

## 현재 완료한 단계

- 기본 재생 제어
- `currentTime = 0` 되감기
- 볼륨 조절
- 반복 재생 상태 구조 정리
- 좌우 팬 조절

## 다음 단계

`rate`를 추가해서 재생 속도를 바꾸고, 속도 변화가 피치 변화와 함께 들리는지 확인한다.
