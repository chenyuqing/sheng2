//
//  TTSView.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import SwiftUI
import SwiftData

struct TTSView: View {
    @State private var viewModel = TTSViewModel()
    @Binding var apiSettings: APISettings
    @Query private var voiceSamples: [VoiceSample]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 语言选择
                Picker("选择语言", selection: $viewModel.ttsModel.selectedLanguage) {
                    ForEach(Language.allCases) { language in
                        Text(language.rawValue).tag(language)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: viewModel.ttsModel.selectedLanguage) { _, _ in
                    // 重置选择的声音样本
                    viewModel.ttsModel.selectedVoiceURL = nil
                }
                
                // 文本输入
                VStack(alignment: .leading) {
                    Text("输入要合成的文本:")
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.ttsModel.customText)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .overlay(
                            Text(viewModel.ttsModel.customText.isEmpty ? viewModel.ttsModel.selectedLanguage.ttsPrompt : "")
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(8)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .allowsHitTesting(false)
                        )
                }
                .padding(.horizontal)
                
                // 声音样本选择
                VStack(alignment: .leading) {
                    Text("选择声音样本:")
                        .font(.headline)
                    
                    if viewModel.filteredSamples.isEmpty {
                        Text("没有可用的\(viewModel.ttsModel.selectedLanguage.rawValue)声音样本")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.filteredSamples) { sample in
                                    Button(action: {
                                        viewModel.selectVoiceSample(sample)
                                    }) {
                                        VStack {
                                            Image(systemName: "person.crop.circle.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(viewModel.ttsModel.selectedVoiceURL == sample.url ? .blue : .gray)
                                            
                                            Text(sample.name)
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                        .frame(width: 80, height: 80)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(viewModel.ttsModel.selectedVoiceURL == sample.url ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(viewModel.ttsModel.selectedVoiceURL == sample.url ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 100)
                    }
                }
                .padding(.horizontal)
                
                // TTS控制
                VStack(spacing: 15) {
                    HStack(spacing: 30) {
                        Button(action: {
                            Task {
                                await viewModel.synthesizeVoice(apiSettings: apiSettings)
                            }
                        }) {
                            VStack {
                                Image(systemName: "text.badge.plus")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                                
                                Text("合成语音")
                                    .font(.caption)
                            }
                        }
                        .disabled(viewModel.ttsModel.selectedVoiceURL == nil || viewModel.ttsModel.isSynthesizing || !apiSettings.isConnected)
                        .opacity((viewModel.ttsModel.selectedVoiceURL == nil || viewModel.ttsModel.isSynthesizing || !apiSettings.isConnected) ? 0.5 : 1)
                        
                        Button(action: {
                            viewModel.playSynthesizedVoice()
                        }) {
                            VStack {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.green)
                                
                                Text("播放合成")
                                    .font(.caption)
                            }
                        }
                        .disabled(viewModel.ttsModel.synthesizedAudioURL == nil)
                        .opacity(viewModel.ttsModel.synthesizedAudioURL == nil ? 0.5 : 1)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                if viewModel.ttsModel.isSynthesizing {
                    ProgressView("正在合成语音...")
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
            .navigationTitle("TTS合成")
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("确定", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview {
    TTSView(apiSettings: .constant(APISettings()))
        .modelContainer(for: VoiceSample.self, inMemory: true)
}