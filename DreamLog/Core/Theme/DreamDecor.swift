//
//  DreamDecor.swift
//  DreamLog
//

import SwiftUI

enum DreamDecor {
    static let screenDeep = LinearGradient(
        colors: [
            Color(red: 0.075, green: 0.065, blue: 0.11),
            Color.dreamBackground,
            Color(red: 0.035, green: 0.03, blue: 0.055)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let radialMysticTop = RadialGradient(
        colors: [Color.dreamMystic.opacity(0.28), Color.clear],
        center: .topLeading,
        startRadius: 20,
        endRadius: 420
    )

    static let radialLucidBottom = RadialGradient(
        colors: [Color.dreamLucid.opacity(0.14), Color.clear],
        center: .bottomTrailing,
        startRadius: 10,
        endRadius: 380
    )

    static let cardGlass = LinearGradient(
        colors: [
            Color.white.opacity(0.1),
            Color.dreamMystic.opacity(0.22),
            Color.dreamBackground.opacity(0.55)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardDeep = LinearGradient(
        colors: [
            Color.dreamMystic.opacity(0.35),
            Color.dreamMystic.opacity(0.12),
            Color.black.opacity(0.35)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let panelMist = LinearGradient(
        colors: [
            Color.dreamMystic.opacity(0.38),
            Color.dreamMystic.opacity(0.14),
            Color.dreamBackground.opacity(0.45)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let borderGlow = LinearGradient(
        colors: [
            Color.white.opacity(0.22),
            Color.dreamLucid.opacity(0.42),
            Color.dreamMystic.opacity(0.45)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let buttonPrimary = LinearGradient(
        colors: [
            Color.dreamLucid,
            Color.dreamLucid.opacity(0.82),
            Color(red: 0.1, green: 0.58, blue: 0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let innerSheen = LinearGradient(
        colors: [Color.white.opacity(0.18), Color.clear],
        startPoint: .top,
        endPoint: .center
    )

    static func accentBorder(accent: Color) -> LinearGradient {
        LinearGradient(
            colors: [Color.white.opacity(0.12), accent.opacity(0.55), Color.dreamMystic.opacity(0.35)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static let shadowDeep = Color.black.opacity(0.45)
    static let shadowLift = Color.dreamMystic.opacity(0.22)
    static let glowLucid = Color.dreamLucid.opacity(0.35)
}

struct DreamScreenBackground: View {
    var body: some View {
        ZStack {
            DreamDecor.screenDeep
            DreamDecor.radialMysticTop
            DreamDecor.radialLucidBottom
        }
        .ignoresSafeArea()
    }
}

extension View {
    /// Full screen atmospheric background (radials + depth gradient).
    func dreamScreenBackdrop() -> some View {
        background(DreamScreenBackground())
    }

    /// Elevated card: gradient fill, rim light, layered shadows.
    func dreamCardChrome(cornerRadius: CGFloat = 16, border: LinearGradient = DreamDecor.borderGlow) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(DreamDecor.cardGlass)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(border, lineWidth: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(DreamDecor.innerSheen, lineWidth: 12)
                .blur(radius: 6)
                .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        )
        .shadow(color: DreamDecor.shadowDeep, radius: 18, x: 0, y: 12)
        .shadow(color: DreamDecor.shadowLift, radius: 10, x: 0, y: 5)
    }

    /// Deeper panel (month picker, stat sections).
    func dreamDeepPanel(cornerRadius: CGFloat = 20) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(DreamDecor.panelMist)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(DreamDecor.borderGlow, lineWidth: 1)
        )
        .shadow(color: DreamDecor.shadowDeep.opacity(0.85), radius: 20, x: 0, y: 14)
        .shadow(color: DreamDecor.glowLucid.opacity(0.25), radius: 16, x: 0, y: 6)
    }

    func dreamFloatingButtonShadow() -> some View {
        self
            .shadow(color: DreamDecor.glowLucid, radius: 14, x: 0, y: 8)
            .shadow(color: DreamDecor.shadowDeep, radius: 20, x: 0, y: 14)
    }

    /// Primary CTA capsule with gradient + depth.
    func dreamPrimaryButtonShape(cornerRadius: CGFloat = 14) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(DreamDecor.buttonPrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.dreamLucid.opacity(0.4), radius: 12, x: 0, y: 6)
        .shadow(color: DreamDecor.shadowDeep.opacity(0.55), radius: 14, x: 0, y: 8)
    }

    /// Secondary outlined control.
    func dreamSecondaryButtonShape(cornerRadius: CGFloat = 14) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.dreamMystic.opacity(0.25))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(DreamDecor.borderGlow, lineWidth: 1)
        )
        .shadow(color: DreamDecor.shadowDeep.opacity(0.4), radius: 12, x: 0, y: 6)
    }

    func dreamCompactRowFill(cornerRadius: CGFloat = 16) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(DreamDecor.cardGlass)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(DreamDecor.innerSheen, lineWidth: 8)
                .blur(radius: 4)
                .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        )
    }

    /// Inner content block (detail sheets, notes) — softer depth than full cards.
    func dreamInsetPanel(cornerRadius: CGFloat = 14) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(DreamDecor.cardGlass)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.14), Color.dreamLucid.opacity(0.28), Color.dreamMystic.opacity(0.32)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: DreamDecor.shadowDeep.opacity(0.38), radius: 12, x: 0, y: 6)
        .shadow(color: DreamDecor.shadowLift.opacity(0.6), radius: 6, x: 0, y: 3)
    }
}
