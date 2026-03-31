//
//  DayCell.swift
//  DreamLog
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let hasDream: Bool
    let dreamType: DreamType?
    let isSelected: Bool
    var lunarMark: MoonPhaseHelper.LunarMark = .none

    private var day: Int {
        Calendar.current.component(.day, from: date)
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("\(day)")
                .font(.caption)
                .foregroundColor(.white)
                .fontWeight(isSelected ? .bold : .regular)
            if hasDream {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                dreamType?.color ?? .dreamLucid,
                                (dreamType?.color ?? .dreamLucid).opacity(0.5)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 6
                        )
                    )
                    .frame(width: 7, height: 7)
                    .shadow(color: (dreamType?.color ?? .dreamLucid).opacity(0.55), radius: 3, x: 0, y: 1)
            } else {
                Color.clear.frame(width: 7, height: 7)
            }
            LunarPhaseGlyph(mark: lunarMark)
                .scaleEffect(1.25)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .padding(.horizontal, 2)
        .background(cellBackground)
        .overlay(
            Group {
                if isSelected {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(DreamDecor.borderGlow, lineWidth: 1)
                }
            }
        )
        .shadow(color: isSelected ? DreamDecor.glowLucid.opacity(0.35) : .clear, radius: 8, x: 0, y: 3)
        .shadow(color: isSelected ? DreamDecor.shadowDeep.opacity(0.5) : .clear, radius: 10, x: 0, y: 5)
    }

    private var cellBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(
                isSelected
                    ? LinearGradient(
                        colors: [
                            Color.dreamMystic.opacity(0.55),
                            Color.dreamMystic.opacity(0.28),
                            Color.dreamBackground.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    : LinearGradient(
                        colors: [
                            Color.dreamMystic.opacity(0.12),
                            Color.dreamBackground.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
            )
    }
}
