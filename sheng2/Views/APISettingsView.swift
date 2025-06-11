//
//  APISettingsView.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import SwiftUI

struct APISettingsView: View {
    @State private var viewModel = APISettingsViewModel()
    @Binding var apiSettings: APISettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("API设置")) {
                    TextField("供应商", text: $viewModel.apiSettings.provider)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    TextField("Base URL", text: $viewModel.apiSettings.baseURL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                    
                    SecureField("API Key", text: $viewModel.apiSettings.apiKey)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section {
                    Button(action: {
                        Task {
                            await viewModel.testConnection()
                        }
                    }) {
                        HStack {
                            Text("测试连接")
                            Spacer()
                            if viewModel.isTestingConnection {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(viewModel.isTestingConnection)
                }
                
                if viewModel.apiSettings.isConnected {
                    Section {
                        Button("保存并返回") {
                            apiSettings = viewModel.apiSettings
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("API设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("确定", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
            .onAppear {
                viewModel.apiSettings = apiSettings
            }
        }
    }
}

#Preview {
    APISettingsView(apiSettings: .constant(APISettings()))
}