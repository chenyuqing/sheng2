//
//  MainView.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import SwiftUI

struct MainView: View {
    @State private var apiSettings = APISettings()
    @State private var showAPISettings = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首页/API设置
            HomeView(apiSettings: $apiSettings, showAPISettings: $showAPISettings)
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            // 声音克隆
            VoiceCloneView(apiSettings: $apiSettings)
                .tabItem {
                    Label("声音克隆", systemImage: "waveform")
                }
                .tag(1)
            
            // TTS合成
            TTSView(apiSettings: $apiSettings)
                .tabItem {
                    Label("TTS合成", systemImage: "text.bubble")
                }
                .tag(2)
        }
        .sheet(isPresented: $showAPISettings) {
            APISettingsView(apiSettings: $apiSettings)
        }
    }
}

struct HomeView: View {
    @Binding var apiSettings: APISettings
    @Binding var showAPISettings: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "waveform.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("声音克隆与TTS合成")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("使用AI技术克隆您的声音并生成自然语音")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                    .frame(height: 40)
                
                // API状态卡片
                VStack(spacing: 15) {
                    HStack {
                        Text("API连接状态")
                            .font(.headline)
                        
                        Spacer()
                        
                        Circle()
                            .fill(apiSettings.isConnected ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                        
                        Text(apiSettings.isConnected ? "已连接" : "未连接")
                            .font(.subheadline)
                            .foregroundColor(apiSettings.isConnected ? .green : .red)
                    }
                    
                    if apiSettings.isConnected {
                        Divider()
                        
                        HStack {
                            Text("供应商:")
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text(apiSettings.provider)
                        }
                        
                        HStack {
                            Text("Base URL:")
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text(apiSettings.baseURL)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    }
                    
                    Button(action: {
                        showAPISettings = true
                    }) {
                        Text(apiSettings.isConnected ? "修改API设置" : "配置API")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
                
                // 功能介绍
                VStack(alignment: .leading, spacing: 15) {
                    Text("主要功能:")
                        .font(.headline)
                    
                    HStack(spacing: 15) {
                        Image(systemName: "waveform")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("声音克隆")
                                .fontWeight(.medium)
                            
                            Text("录制您的声音并创建AI声音模型")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack(spacing: 15) {
                        Image(systemName: "text.bubble")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("TTS合成")
                                .fontWeight(.medium)
                            
                            Text("使用您的声音模型将文本转换为语音")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("声音助手")
            .padding(.vertical)
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: VoiceSample.self, inMemory: true)
}