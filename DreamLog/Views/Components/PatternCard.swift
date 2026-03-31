//
//  PatternCard.swift
//  DreamLog
//

import SwiftUI

struct PatternCard: View {
    let pattern: DreamPattern

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(pattern.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(pattern.frequency)×")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.dreamLucid.opacity(0.35), Color.dreamLucid.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.dreamLucid.opacity(0.45), lineWidth: 1)
                    )
                    .foregroundColor(.dreamLucid)
            }
            Text(pattern.description)
                .font(.caption)
                .foregroundColor(.gray)
            if !pattern.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(pattern.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption2)
                                .foregroundColor(.dreamMystic)
                        }
                    }
                }
            }
            Text("Last seen: \(formattedShortDate(pattern.lastOccurrence))")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DreamDecor.cardGlass)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DreamDecor.borderGlow, lineWidth: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DreamDecor.innerSheen, lineWidth: 10)
                .blur(radius: 5)
                .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
        )
        .shadow(color: DreamDecor.shadowDeep, radius: 16, x: 0, y: 10)
        .shadow(color: DreamDecor.shadowLift, radius: 8, x: 0, y: 5)
    }
}
