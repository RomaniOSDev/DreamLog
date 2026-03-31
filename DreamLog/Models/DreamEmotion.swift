//
//  DreamEmotion.swift
//  DreamLog
//

import Foundation

enum DreamEmotion: String, CaseIterable, Codable, Hashable {
    case joy = "Joy"
    case fear = "Fear"
    case curiosity = "Curiosity"
    case sadness = "Sadness"
    case excitement = "Excitement"
    case peace = "Peace"
    case confusion = "Confusion"
    case wonder = "Wonder"

    var icon: String {
        switch self {
        case .joy: return "face.smiling"
        case .fear: return "face.dashed"
        case .curiosity: return "magnifyingglass"
        case .sadness: return "cloud.rain"
        case .excitement: return "bolt"
        case .peace: return "leaf"
        case .confusion: return "questionmark"
        case .wonder: return "star"
        }
    }
}
