//
//  StatCard.swift
//  DreamLog
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let cardColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Text(value)
                .foregroundColor(.white)
                .font(.title2)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(DreamDecor.cardGlass)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(cardColor.opacity(0.42))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(DreamDecor.borderGlow, lineWidth: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(DreamDecor.innerSheen, lineWidth: 10)
                .blur(radius: 5)
                .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
        )
        .shadow(color: DreamDecor.shadowDeep, radius: 16, x: 0, y: 10)
        .shadow(color: DreamDecor.shadowLift, radius: 8, x: 0, y: 4)
    }
}
