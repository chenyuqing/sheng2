//
//  VoiceCloneView.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import SwiftUI
import SwiftData

struct VoiceCloneView: View {
    @State private var viewModel = VoiceCloneViewModel()
    @Binding var apiSettings: APISettings
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 语言选择
                Picker("选择语言", selection: $viewModel.voiceCloneModel.selectedLanguage) {
                    ForEach(Language.allCases) { language in
                        Text(language.rawValue).tag(language)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // 提示文本
                ScrollView {
                    Text(viewModel.voiceCloneModel.selectedLanguage.recordingPrompt)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .frame(height: 150)
                .padding(.horizontal)
                
                // 录音控制
                VStack(spacing: 15) {
                    HStack(spacing: 30) {
                        Button(action: {
                            if viewModel.voiceCloneModel.isRecording {
                                viewModel.stopRecording()
                            } else {
                                viewModel.startRecording()
                            }
                        }) {
                            VStack {
                                Image(systemName: viewModel.voiceCloneModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(viewModel.voiceCloneModel.isRecording ? .red : .blue)
                                
                                Text(viewModel.voiceCloneModel.isRecording ? "停止录音" : "开始录音")
                                    .font(.caption)
                            }
                        }
                        
                        Button(action: {
                            viewModel.playRecording()
                        }) {
                            VStack {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.green)
                                
                                Text("播放录音")
                                    .font(.caption)
                            }
                        }
                        .disabled(viewModel.voiceCloneModel.recordedAudioURL == nil)
                        .opacity(viewModel.voiceCloneModel.recordedAudioURL == nil ? 0.5 : 1)
                    }
                    
                    Divider()
                    
                    // 声音样本名称
                    TextField("声音样本名称", text: $viewModel.sampleName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // 克隆控制
                    HStack(spacing: 30) {
                        Button(action: {
                            Task {
                                await viewModel.cloneVoice(apiSettings: apiSettings, modelContext: modelContext)
                            }
                        }) {
                            VStack {
                                Image(systemName: "waveform.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.purple)
                                
                                Text("克隆声音")
                                    .font(.caption)
                            }
                        }
                        .disabled(viewModel.voiceCloneModel.recordedAudioURL == nil || viewModel.voiceCloneModel.isCloning || !apiSettings.isConnected)
                        .opacity((viewModel.voiceCloneModel.recordedAudioURL == nil || viewModel.voiceCloneModel.isCloning || !apiSettings.isConnected) ? 0.5 : 1)
                        
                        Button(action: {
                            viewModel.playClonedVoice()
                        }) {
                            VStack {
                                Image(systemName: "speaker.wave.2.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.orange)
                                
                                Text("播放克隆")
                                    .font(.caption)
                            }
                        }
                        .disabled(viewModel.voiceCloneModel.clonedVoiceURL == nil)
                        .opacity(viewModel.voiceCloneModel.clonedVoiceURL == nil ? 0.5 : 1)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                if viewModel.voiceCloneModel.isCloning {
                    ProgressView("正在克隆声音...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                Spacer()
                
                // API连接状态
                if !apiSettings.isConnected {
                    Text("请先在设置中配置并连接API")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("声音克隆")
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("确定", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview {
    VoiceCloneView(apiSettings: .constant(APISettings()))
        .modelContainer(for: VoiceSample.self, inMemory: true)
}