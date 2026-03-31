//
//  DreamPattern.swift
//  DreamLog
//

import Foundation

struct DreamPattern: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var tags: [String]
    var frequency: Int
    var lastOccurrence: Date
}
