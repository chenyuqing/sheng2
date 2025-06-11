//
//  APISettingsViewModel.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import Foundation
import SwiftUI

@Observable
final class APISettingsViewModel {
    var apiSettings = APISettings()
    var isTestingConnection = false
    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    
    func testConnection() async {
        guard !apiSettings.provider.isEmpty, !apiSettings.baseURL.isEmpty, !apiSettings.apiKey.isEmpty else {
            showAlert(title: "输入错误", message: "请填写所有字段")
            return
        }
        
        isTestingConnection = true
        let success = await apiSettings.testConnection()
        isTestingConnection = false
        
        if success {
            showAlert(title: "连接成功", message: "API连接测试成功")
        } else {
            showAlert(title: "连接失败", message: "无法连接到API，请检查您的设置")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}