//
//  MoonPhaseHelper.swift
//  DreamLog
//

import Foundation

enum MoonPhaseHelper {
    /// 0...1 over synodic month (simplified).
    static func phaseFraction(for date: Date) -> Double {
        let calendar = Calendar.current
        let knownNewMoon = calendar.date(from: DateComponents(year: 2000, month: 1, day: 6)) ?? date
        let days = date.timeIntervalSince(knownNewMoon) / 86400
        let cycle = 29.53058867
        let phase = days.truncatingRemainder(dividingBy: cycle)
        return phase / cycle
    }

    /// Phase evaluated at local noon for stable calendar-day labeling.
    static func phaseFractionForCalendarDay(_ date: Date) -> Double {
        let cal = Calendar.current
        let start = cal.startOfDay(for: date)
        guard let noon = cal.date(byAdding: .hour, value: 12, to: start) else {
            return phaseFraction(for: date)
        }
        return phaseFraction(for: noon)
    }

    enum LunarMark: String, CaseIterable {
        case none
        case newMoon
        case firstQuarter
        case fullMoon
        case lastQuarter

        var shortLabel: String {
            switch self {
            case .none: return ""
            case .newMoon: return "New"
            case .firstQuarter: return "1st Q"
            case .fullMoon: return "Full"
            case .lastQuarter: return "3rd Q"
            }
        }

        /// All phases except `.none` for calendar legend.
        static var calendarLegendCases: [LunarMark] {
            [.newMoon, .firstQuarter, .fullMoon, .lastQuarter]
        }
    }

    /// Highlight for a single calendar day (coarse buckets).
    static func lunarMark(forCalendarDay date: Date) -> LunarMark {
        let p = phaseFractionForCalendarDay(date)
        switch p {
        case 0..<0.06, 0.94...1.0: return .newMoon
        case 0.19..<0.31: return .firstQuarter
        case 0.44..<0.56: return .fullMoon
        case 0.69..<0.81: return .lastQuarter
        default: return .none
        }
    }

    static func label(for date: Date = Date()) -> String {
        let p = phaseFraction(for: date)
        switch p {
        case 0..<0.0625: return "New Moon"
        case 0.0625..<0.1875: return "Waxing Crescent"
        case 0.1875..<0.3125: return "First Quarter"
        case 0.3125..<0.4375: return "Waxing Gibbous"
        case 0.4375..<0.5625: return "Full Moon"
        case 0.5625..<0.6875: return "Waning Gibbous"
        case 0.6875..<0.8125: return "Last Quarter"
        case 0.8125..<0.9375: return "Waning Crescent"
        default: return "New Moon"
        }
    }

    static func greeting(for date: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }
}
