//
//  DreamIntensity.swift
//  DreamLog
//

import Foundation

enum DreamIntensity: Int, CaseIterable, Codable {
    case low = 1
    case medium = 2
    case high = 3
    case intense = 4
    case overwhelming = 5

    var description: String {
        switch self {
        case .low: return "Barely remembered"
        case .medium: return "Moderate clarity"
        case .high: return "Vivid"
        case .intense: return "Very vivid"
        case .overwhelming: return "Cinematic"
        }
    }
}
