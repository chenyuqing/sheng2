//
//  VoiceViewModel.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class VoiceCloneViewModel {
    var voiceCloneModel = VoiceCloneModel()
    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    var sampleName = ""
    
    func startRecording() {
        voiceCloneModel.startRecording()
    }
    
    func stopRecording() {
        voiceCloneModel.stopRecording()
    }
    
    func playRecording() {
        guard voiceCloneModel.recordedAudioURL != nil else {
            showAlert(title: "播放错误", message: "没有可用的录音")
            return
        }
        
        voiceCloneModel.playRecording()
    }
    
    func playClonedVoice() {
        guard voiceCloneModel.clonedVoiceURL != nil else {
            showAlert(title: "播放错误", message: "没有可用的克隆声音")
            return
        }
        
        voiceCloneModel.playClonedVoice()
    }
    
    func cloneVoice(apiSettings: APISettings, modelContext: ModelContext) async {
        guard voiceCloneModel.recordedAudioURL != nil else {
            showAlert(title: "克隆错误", message: "请先录制声音样本")
            return
        }
        
        let success = await voiceCloneModel.cloneVoice(apiSettings: apiSettings)
        
        if success, let clonedURL = voiceCloneModel.clonedVoiceURL {
            // 保存声音样本到数据库
            if !sampleName.isEmpty {
                let sample = VoiceSample(
                    name: sampleName,
                    language: voiceCloneModel.selectedLanguage.rawValue,
                    audioURL: clonedURL.absoluteString
                )
                modelContext.insert(sample)
                showAlert(title: "克隆成功", message: "声音克隆成功并已保存")
            } else {
                showAlert(title: "克隆成功", message: "声音克隆成功，但未保存（未提供名称）")
            }
        } else {
            showAlert(title: "克隆失败", message: "声音克隆过程中出现错误")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

@Observable
final class TTSViewModel {
    var ttsModel = TTSModel()
    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    @Query private var voiceSamples: [VoiceSample]
    
    var filteredSamples: [VoiceSample] {
        voiceSamples.filter { $0.language == ttsModel.selectedLanguage.rawValue }
    }
    
    func selectVoiceSample(_ sample: VoiceSample) {
        ttsModel.selectedVoiceURL = sample.url
    }
    
    func playSynthesizedVoice() {
        guard ttsModel.synthesizedAudioURL != nil else {
            showAlert(title: "播放错误", message: "没有可用的合成声音")
            return
        }
        
        ttsModel.playSynthesizedVoice()
    }
    
    func synthesizeVoice(apiSettings: APISettings) async {
        guard ttsModel.selectedVoiceURL != nil else {
            showAlert(title: "合成错误", message: "请先选择声音样本")
            return
        }
        
        let success = await ttsModel.synthesizeVoice(apiSettings: apiSettings)
        
        if success {
            showAlert(title: "合成成功", message: "文本转语音合成成功")
        } else {
            showAlert(title: "合成失败", message: "文本转语音合成过程中出现错误")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}