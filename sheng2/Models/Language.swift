//
//  Language.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
    case mandarin = "普通话"
    case cantonese = "粤语"
    case english = "英语"
    
    var id: String { self.rawValue }
    
    var recordingPrompt: String {
        switch self {
        case .mandarin:
            return "请朗读以下文字：人工智能正在改变我们的生活方式，让科技与人类更好地融合。未来的发展将会更加智能化，为人类创造更多可能性。"
        case .cantonese:
            return "请用粤语朗读以下文字：人工智能正在改变我哋嘅生活方式，令科技同人类更好咁融合。未来嘅发展会更加智能化，为人类创造更多可能性。"
        case .english:
            return "Please read the following text: Artificial intelligence is changing the way we live, enabling better integration of technology and humanity. Future developments will be increasingly intelligent, creating more possibilities for mankind."
        }
    }
    
    var ttsPrompt: String {
        switch self {
        case .mandarin:
            return "Google Veo 3 是先进的AI视频生成模型，支持文字生成高质量带音频的4K视频，具备精细控制与安全水印，创作专业短片更轻松。"
        case .cantonese:
            return "Google Veo 3 系先进嘅AI视频生成模型，支持文字生成高质量带音频嘅4K视频，具备精细控制与安全水印，创作专业短片更加容易。"
        case .english:
            return "Google Veo 3 is an advanced AI video generation model that supports text-to-video creation with high-quality 4K resolution and audio. It features fine-grained control and security watermarks, making professional short video creation easier."
        }
    }
}