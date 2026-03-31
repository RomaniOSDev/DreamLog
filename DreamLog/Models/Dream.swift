//
//  Dream.swift
//  DreamLog
//

import Foundation

struct Dream: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var title: String
    var description: String
    var type: DreamType
    var intensity: DreamIntensity
    var emotions: [DreamEmotion]
    var tags: [String]
    var characters: [String]?
    var locations: [String]?
    var duration: Int?
    var isFavorite: Bool
    var notes: String?
    /// Short line: what the dream might be telling you (letter to yourself).
    var messageToSelf: String?
    /// IDs of symbols from the library linked to this dream.
    var linkedSymbolIds: [UUID]
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, date, title, description, type, intensity, emotions, tags
        case characters, locations, duration, isFavorite, notes, createdAt
        case messageToSelf, linkedSymbolIds
    }

    init(
        id: UUID,
        date: Date,
        title: String,
        description: String,
        type: DreamType,
        intensity: DreamIntensity,
        emotions: [DreamEmotion],
        tags: [String],
        characters: [String]?,
        locations: [String]?,
        duration: Int?,
        isFavorite: Bool,
        notes: String?,
        messageToSelf: String? = nil,
        linkedSymbolIds: [UUID] = [],
        createdAt: Date
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.description = description
        self.type = type
        self.intensity = intensity
        self.emotions = emotions
        self.tags = tags
        self.characters = characters
        self.locations = locations
        self.duration = duration
        self.isFavorite = isFavorite
        self.notes = notes
        self.messageToSelf = messageToSelf
        self.linkedSymbolIds = linkedSymbolIds
        self.createdAt = createdAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        date = try c.decode(Date.self, forKey: .date)
        title = try c.decode(String.self, forKey: .title)
        description = try c.decode(String.self, forKey: .description)
        type = try c.decode(DreamType.self, forKey: .type)
        intensity = try c.decode(DreamIntensity.self, forKey: .intensity)
        emotions = try c.decode([DreamEmotion].self, forKey: .emotions)
        tags = try c.decode([String].self, forKey: .tags)
        characters = try c.decodeIfPresent([String].self, forKey: .characters)
        locations = try c.decodeIfPresent([String].self, forKey: .locations)
        duration = try c.decodeIfPresent(Int.self, forKey: .duration)
        isFavorite = try c.decode(Bool.self, forKey: .isFavorite)
        notes = try c.decodeIfPresent(String.self, forKey: .notes)
        messageToSelf = try c.decodeIfPresent(String.self, forKey: .messageToSelf)
        linkedSymbolIds = try c.decodeIfPresent([UUID].self, forKey: .linkedSymbolIds) ?? []
        createdAt = try c.decode(Date.self, forKey: .createdAt)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(date, forKey: .date)
        try c.encode(title, forKey: .title)
        try c.encode(description, forKey: .description)
        try c.encode(type, forKey: .type)
        try c.encode(intensity, forKey: .intensity)
        try c.encode(emotions, forKey: .emotions)
        try c.encode(tags, forKey: .tags)
        try c.encodeIfPresent(characters, forKey: .characters)
        try c.encodeIfPresent(locations, forKey: .locations)
        try c.encodeIfPresent(duration, forKey: .duration)
        try c.encode(isFavorite, forKey: .isFavorite)
        try c.encodeIfPresent(notes, forKey: .notes)
        try c.encodeIfPresent(messageToSelf, forKey: .messageToSelf)
        try c.encode(linkedSymbolIds, forKey: .linkedSymbolIds)
        try c.encode(createdAt, forKey: .createdAt)
    }
}
