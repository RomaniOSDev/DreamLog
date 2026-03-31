//
//  DreamCard.swift
//  DreamLog
//

import SwiftUI

struct DreamCard: View {
    let dream: Dream

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: dream.type.icon)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [dream.type.color, dream.type.color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(dream.title)
                        .foregroundColor(.white)
                        .font(.headline)
                    Text(dream.type.rawValue)
                        .font(.caption)
                        .foregroundColor(dream.type.color)
                }
                Spacer()
                if dream.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .font(.caption)
                }
            }
            Text(dream.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
            if let note = dream.messageToSelf, !note.isEmpty {
                Text(note)
                    .font(.caption2)
                    .italic()
                    .foregroundColor(.dreamLucid.opacity(0.9))
                    .lineLimit(2)
            }
            HStack {
                ForEach(Array(dream.emotions.prefix(3)), id: \.self) { emotion in
                    Image(systemName: emotion.icon)
                        .font(.caption2)
                        .foregroundColor(.dreamMystic)
                }
                Spacer()
                HStack(spacing: 2) {
                    ForEach(1...dream.intensity.rawValue, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.dreamLucid)
                    }
                }
            }
            if !dream.tags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(Array(dream.tags.prefix(3)), id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption2)
                            .foregroundColor(.dreamMystic)
                            .lineLimit(1)
                    }
                    if dream.tags.count > 3 {
                        Text("…")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DreamDecor.cardGlass)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(dream.type.color.opacity(0.08))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DreamDecor.accentBorder(accent: dream.type.color), lineWidth: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DreamDecor.innerSheen, lineWidth: 12)
                .blur(radius: 6)
                .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
        )
        .shadow(color: DreamDecor.shadowDeep, radius: 18, x: 0, y: 12)
        .shadow(color: dream.type.color.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}
