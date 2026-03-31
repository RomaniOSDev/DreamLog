//
//  SymbolCard.swift
//  DreamLog
//

import SwiftUI

struct SymbolCard: View {
    let symbol: DreamSymbol

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(symbol.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    if symbol.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.75)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .font(.caption)
                    }
                }
                Text(symbol.meaning)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                if !symbol.tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(Array(symbol.tags.prefix(3)), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption2)
                                .foregroundColor(.dreamMystic)
                                .lineLimit(1)
                        }
                        if symbol.tags.count > 3 {
                            Text("…")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            Spacer()
            Image(systemName: "eye")
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.dreamMystic, Color.dreamMystic.opacity(0.65)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DreamDecor.cardGlass)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DreamDecor.accentBorder(accent: .dreamMystic), lineWidth: 1)
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
