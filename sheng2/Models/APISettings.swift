//
//  APISettings.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import Foundation
import SwiftData

@Observable
final class APISettings {
    var provider: String = ""
    var baseURL: String = ""
    var apiKey: String = ""
    var isConnected: Bool = false
    
    func testConnection() async -> Bool {
        // 模拟 API 连接测试
        // 实际应用中，这里应该发送一个测试请求到 baseURL 验证 apiKey 是否有效
        do {
            // 模拟网络延迟
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // 简单验证输入是否为空
            guard !provider.isEmpty, !baseURL.isEmpty, !apiKey.isEmpty else {
                isConnected = false
                return false
            }
            
            // 模拟连接成功
            isConnected = true
            return true
        } catch {
            isConnected = false
            return false
        }
    }
}