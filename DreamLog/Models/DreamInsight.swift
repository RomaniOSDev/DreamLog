//
//  DreamInsight.swift
//  DreamLog
//

import Foundation

struct DreamInsight: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    var insight: String
    var dreamId: UUID
    var tags: [String]
}
