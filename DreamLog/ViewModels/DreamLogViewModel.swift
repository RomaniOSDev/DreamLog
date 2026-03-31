//
//  DreamLogViewModel.swift
//  DreamLog
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class DreamLogViewModel: ObservableObject {
    @Published var dreams: [Dream] = []
    @Published var symbols: [DreamSymbol] = []
    @Published var patterns: [DreamPattern] = []
    @Published var insights: [DreamInsight] = []

    var totalDreams: Int { dreams.count }

    var lucidCount: Int {
        dreams.filter { $0.type == .lucid }.count
    }

    var nightmareCount: Int {
        dreams.filter { $0.type == .nightmare }.count
    }

    var monthlyCount: Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        return dreams.filter {
            calendar.component(.month, from: $0.date) == month &&
                calendar.component(.year, from: $0.date) == year
        }.count
    }

    var streakDays: Int {
        let calendar = Calendar.current
        var streak = 0
        var date = calendar.startOfDay(for: Date())
        while true {
            let hasDream = dreams.contains { calendar.isDate($0.date, inSameDayAs: date) }
            if hasDream {
                streak += 1
                guard let prev = calendar.date(byAdding: .day, value: -1, to: date) else { break }
                date = prev
            } else {
                break
            }
        }
        return streak
    }

    var recallRate: Double {
        let calendar = Calendar.current
        let daysInMonth = calendar.range(of: .day, in: .month, for: Date())?.count ?? 30
        guard daysInMonth > 0 else { return 0 }
        return Double(monthlyCount) / Double(daysInMonth) * 100
    }

    func hasDream(on date: Date) -> Bool {
        let calendar = Calendar.current
        return dreams.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func dreamType(on date: Date) -> DreamType? {
        let calendar = Calendar.current
        return dreams.first { calendar.isDate($0.date, inSameDayAs: date) }?.type
    }

    func dreamsOnDate(_ date: Date) -> [Dream] {
        let calendar = Calendar.current
        return dreams.filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date > $1.date }
    }

    func dreams(linkingSymbolId symbolId: UUID) -> [Dream] {
        dreams
            .filter { $0.linkedSymbolIds.contains(symbolId) }
            .sorted { $0.date > $1.date }
    }

    struct MonthlyData: Identifiable {
        let period: Date
        let month: String
        let count: Int
        var id: Date { period }
    }

    var monthlyDreams: [MonthlyData] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: dreams) { dream -> Date in
            let c = calendar.dateComponents([.year, .month], from: dream.date)
            return calendar.date(from: c) ?? dream.date
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return grouped.map { date, dreams in
            MonthlyData(period: date, month: formatter.string(from: date), count: dreams.count)
        }
        .sorted { $0.period < $1.period }
    }

    struct TypeDistribution: Identifiable {
        let id: DreamType
        let name: String
        let icon: String
        let color: Color
        let count: Int
        let percentage: Double
    }

    var typeDistribution: [TypeDistribution] {
        let grouped = Dictionary(grouping: dreams, by: \.type)
        let total = Double(dreams.count)
        return grouped.map { type, items in
            TypeDistribution(
                id: type,
                name: type.rawValue,
                icon: type.icon,
                color: type.color,
                count: items.count,
                percentage: total > 0 ? Double(items.count) / total * 100 : 0
            )
        }
        .sorted { $0.count > $1.count }
    }

    struct EmotionStat: Identifiable {
        let id: DreamEmotion
        let name: String
        let icon: String
        let count: Int
    }

    var topEmotions: [EmotionStat] {
        let all = dreams.flatMap(\.emotions)
        let grouped = Dictionary(grouping: all, by: { $0 })
        return grouped.map { emotion, items in
            EmotionStat(id: emotion, name: emotion.rawValue, icon: emotion.icon, count: items.count)
        }
        .sorted { $0.count > $1.count }
        .prefix(5)
        .map { $0 }
    }

    func addDream(_ dream: Dream) {
        dreams.append(dream)
        updatePatterns(with: dream)
        saveToUserDefaults()
    }

    func updateDream(_ dream: Dream) {
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
            saveToUserDefaults()
        }
    }

    func deleteDream(_ dream: Dream) {
        dreams.removeAll { $0.id == dream.id }
        saveToUserDefaults()
    }

    func toggleFavorite(_ dream: Dream) {
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }

    func addSymbol(_ symbol: DreamSymbol) {
        symbols.append(symbol)
        saveToUserDefaults()
    }

    func updateSymbol(_ symbol: DreamSymbol) {
        if let index = symbols.firstIndex(where: { $0.id == symbol.id }) {
            symbols[index] = symbol
            saveToUserDefaults()
        }
    }

    func deleteSymbol(_ symbol: DreamSymbol) {
        let sid = symbol.id
        symbols.removeAll { $0.id == sid }
        for i in dreams.indices {
            dreams[i].linkedSymbolIds.removeAll { $0 == sid }
        }
        saveToUserDefaults()
    }

    func toggleFavoriteSymbol(_ symbol: DreamSymbol) {
        if let index = symbols.firstIndex(where: { $0.id == symbol.id }) {
            symbols[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }

    private func updatePatterns(with dream: Dream) {
        for tag in dream.tags {
            if let index = patterns.firstIndex(where: { $0.tags.contains(tag) }) {
                patterns[index].frequency += 1
                patterns[index].lastOccurrence = dream.date
            } else {
                let pattern = DreamPattern(
                    id: UUID(),
                    name: "Linked to “\(tag)”",
                    description: "Recurring motif: \(tag)",
                    tags: [tag],
                    frequency: 1,
                    lastOccurrence: dream.date
                )
                patterns.append(pattern)
            }
        }
    }

    private let dreamsKey = "dreamlog_dreams"
    private let symbolsKey = "dreamlog_symbols"
    private let patternsKey = "dreamlog_patterns"
    private let insightsKey = "dreamlog_insights"

    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dreams) {
            UserDefaults.standard.set(encoded, forKey: dreamsKey)
        }
        if let encoded = try? JSONEncoder().encode(symbols) {
            UserDefaults.standard.set(encoded, forKey: symbolsKey)
        }
        if let encoded = try? JSONEncoder().encode(patterns) {
            UserDefaults.standard.set(encoded, forKey: patternsKey)
        }
        if let encoded = try? JSONEncoder().encode(insights) {
            UserDefaults.standard.set(encoded, forKey: insightsKey)
        }
    }

    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: dreamsKey),
           let decoded = try? JSONDecoder().decode([Dream].self, from: data) {
            dreams = decoded
        }
        if let data = UserDefaults.standard.data(forKey: symbolsKey),
           let decoded = try? JSONDecoder().decode([DreamSymbol].self, from: data) {
            symbols = decoded
        }
        if let data = UserDefaults.standard.data(forKey: patternsKey),
           let decoded = try? JSONDecoder().decode([DreamPattern].self, from: data) {
            patterns = decoded
        }
        if let data = UserDefaults.standard.data(forKey: insightsKey),
           let decoded = try? JSONDecoder().decode([DreamInsight].self, from: data) {
            insights = decoded
        }
        if dreams.isEmpty {
            loadDemoData()
        }
    }

    private func loadDemoData() {
        let flightSymbolId = UUID()
        let dream1 = Dream(
            id: UUID(),
            date: Date().addingTimeInterval(-86400 * 2),
            title: "Flight over the city",
            description: "I soared above a city at night, feeling completely free. It felt bright and real.",
            type: .lucid,
            intensity: .intense,
            emotions: [.joy, .excitement],
            tags: ["flight", "city", "freedom"],
            characters: ["me"],
            locations: ["night city"],
            duration: 15,
            isFavorite: true,
            notes: "First lucid dream!",
            messageToSelf: "You already know how to rise above what weighs you down.",
            linkedSymbolIds: [flightSymbolId],
            createdAt: Date()
        )
        let dream2 = Dream(
            id: UUID(),
            date: Date().addingTimeInterval(-86400 * 5),
            title: "The forgotten house",
            description: "I wandered an old house that felt familiar though I had never seen it.",
            type: .recurring,
            intensity: .high,
            emotions: [.curiosity, .wonder],
            tags: ["house", "mystery", "memories"],
            characters: nil,
            locations: ["old house"],
            duration: 20,
            isFavorite: false,
            notes: "Third time dreaming this",
            messageToSelf: "Something old wants to be acknowledged, not fixed in a hurry.",
            linkedSymbolIds: [],
            createdAt: Date()
        )
        dreams = [dream1, dream2]
        symbols = [
            DreamSymbol(
                id: flightSymbolId,
                name: "Flight",
                meaning: "Freedom, ascent, and release from limits",
                tags: ["flight", "freedom"],
                isFavorite: true
            )
        ]
        patterns = [
            DreamPattern(
                id: UUID(),
                name: "Recurring house",
                description: "The old house appears again and again",
                tags: ["house"],
                frequency: 3,
                lastOccurrence: Date().addingTimeInterval(-86400 * 5)
            )
        ]
    }
}
