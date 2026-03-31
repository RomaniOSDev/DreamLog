//
//  DreamType.swift
//  DreamLog
//

import SwiftUI

enum DreamType: String, CaseIterable, Codable {
    case ordinary = "Ordinary"
    case lucid = "Lucid"
    case nightmare = "Nightmare"
    case prophetic = "Prophetic"
    case recurring = "Recurring"

    var icon: String {
        switch self {
        case .ordinary: return "moon.stars"
        case .lucid: return "sparkles"
        case .nightmare: return "cloud.bolt"
        case .prophetic: return "eye"
        case .recurring: return "arrow.2.circlepath"
        }
    }

    var color: Color {
        switch self {
        case .ordinary: return .dreamMystic
        case .lucid: return .dreamLucid
        case .nightmare: return .dreamMystic.opacity(0.7)
        case .prophetic: return .dreamMystic
        case .recurring: return .dreamLucid.opacity(0.7)
        }
    }
}
