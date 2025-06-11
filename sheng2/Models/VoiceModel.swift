//
//  VoiceModel.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import Foundation
import AVFoundation

@Observable
final class VoiceCloneModel {
    var recordedAudioURL: URL?
    var clonedVoiceURL: URL?
    var isRecording = false
    var isCloning = false
    var selectedLanguage: Language = .mandarin
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    // 开始录音
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            recordedAudioURL = documentsPath.appendingPathComponent("voiceRecording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: recordedAudioURL!, settings: settings)
            audioRecorder?.record()
            
            isRecording = true
        } catch {
            print("录音失败: \(error.localizedDescription)")
        }
    }
    
    // 停止录音
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    // 播放录音
    func playRecording() {
        guard let url = recordedAudioURL else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("播放失败: \(error.localizedDescription)")
        }
    }
    
    // 播放克隆的声音
    func playClonedVoice() {
        guard let url = clonedVoiceURL else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("播放失败: \(error.localizedDescription)")
        }
    }
    
    // 克隆声音
    func cloneVoice(apiSettings: APISettings) async -> Bool {
        guard let recordedURL = recordedAudioURL, apiSettings.isConnected else {
            return false
        }
        
        isCloning = true
        
        // 模拟声音克隆过程
        do {
            // 模拟网络延迟
            try await Task.sleep(nanoseconds: 3_000_000_000)
            
            // 模拟克隆成功，实际应用中这里应该调用API进行声音克隆
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            clonedVoiceURL = documentsPath.appendingPathComponent("clonedVoice.m4a")
            
            // 为了演示，我们将录制的声音复制为克隆的声音
            try FileManager.default.copyItem(at: recordedURL, to: clonedVoiceURL!)
            
            isCloning = false
            return true
        } catch {
            print("声音克隆失败: \(error.localizedDescription)")
            isCloning = false
            return false
        }
    }
}

@Observable
final class TTSModel {
    var synthesizedAudioURL: URL?
    var isSynthesizing = false
    var selectedLanguage: Language = .mandarin
    var selectedVoiceURL: URL?
    var customText: String = ""
    var audioPlayer: AVAudioPlayer?
    
    // 播放合成的声音
    func playSynthesizedVoice() {
        guard let url = synthesizedAudioURL else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("播放失败: \(error.localizedDescription)")
        }
    }
    
    // 合成声音
    func synthesizeVoice(apiSettings: APISettings) async -> Bool {
        guard let voiceURL = selectedVoiceURL, apiSettings.isConnected else {
            return false
        }
        
        // 如果用户没有输入文本，使用默认提示文本
        let textToSynthesize = customText.isEmpty ? selectedLanguage.ttsPrompt : customText
        
        isSynthesizing = true
        
        // 模拟TTS合成过程
        do {
            // 模拟网络延迟
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            // 模拟合成成功，实际应用中这里应该调用API进行TTS合成
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            synthesizedAudioURL = documentsPath.appendingPathComponent("synthesizedVoice.m4a")
            
            // 为了演示，我们将选择的声音样本复制为合成的声音
            try FileManager.default.copyItem(at: voiceURL, to: synthesizedAudioURL!)
            
            isSynthesizing = false
            return true
        } catch {
            print("声音合成失败: \(error.localizedDescription)")
            isSynthesizing = false
            return false
        }
    }
}