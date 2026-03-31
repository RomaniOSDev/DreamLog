//
//  CompactDreamRow.swift
//  DreamLog
//

import SwiftUI

struct CompactDreamRow: View {
    let dream: Dream

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: dream.type.icon)
                .font(.title3)
                .foregroundStyle(
                    LinearGradient(
                        colors: [dream.type.color, dream.type.color.opacity(0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(dream.type.color.opacity(0.2))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(dream.type.color.opacity(0.4), lineWidth: 1)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(dream.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(formattedShortDateTime(dream.date))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer(minLength: 0)
            if dream.isFavorite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        }
        .padding(14)
        .dreamCompactRowFill(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DreamDecor.accentBorder(accent: dream.type.color), lineWidth: 1)
        )
        .shadow(color: DreamDecor.shadowDeep.opacity(0.55), radius: 14, x: 0, y: 8)
        .shadow(color: dream.type.color.opacity(0.1), radius: 10, x: 0, y: 4)
    }

    private func formattedShortDateTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM d · HH:mm"
        f.locale = Locale(identifier: "en_US")
        return f.string(from: date)
    }
}
