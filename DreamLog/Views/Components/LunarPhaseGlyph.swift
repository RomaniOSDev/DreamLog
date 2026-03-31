//
//  LunarPhaseGlyph.swift
//  DreamLog
//

import SwiftUI

/// Small marker for moon phase (used in calendar cells and legend).
struct LunarPhaseGlyph: View {
    let mark: MoonPhaseHelper.LunarMark

    var body: some View {
        switch mark {
        case .none:
            Color.clear.frame(width: 10, height: 10)
        case .newMoon:
            Circle()
                .strokeBorder(Color.white.opacity(0.45), lineWidth: 1)
                .frame(width: 9, height: 9)
        case .fullMoon:
            Circle()
                .fill(Color.dreamLucid.opacity(0.95))
                .frame(width: 9, height: 9)
        case .firstQuarter:
            Circle()
                .fill(Color.dreamMystic.opacity(0.85))
                .frame(width: 7, height: 7)
        case .lastQuarter:
            Circle()
                .fill(Color.dreamLucid.opacity(0.4))
                .frame(width: 7, height: 7)
        }
    }
}
