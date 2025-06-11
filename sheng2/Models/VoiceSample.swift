//
//  VoiceSample.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import Foundation
import SwiftData

@Model
final class VoiceSample {
    var name: String
    var language: String
    var audioURL: String
    var createdAt: Date
    
    init(name: String, language: String, audioURL: String) {
        self.name = name
        self.language = language
        self.audioURL = audioURL
        self.createdAt = Date()
    }
    
    var url: URL? {
        URL(string: audioURL)
    }
}