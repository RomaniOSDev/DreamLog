//
//  DreamSymbol.swift
//  DreamLog
//

import Foundation

struct DreamSymbol: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var meaning: String
    var tags: [String]
    var isFavorite: Bool
}
