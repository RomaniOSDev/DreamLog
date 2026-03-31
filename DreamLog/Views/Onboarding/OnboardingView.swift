//
//  OnboardingView.swift
//  DreamLog
//

import SwiftUI

private enum OnboardingStep: Int, CaseIterable, Hashable {
    case capture = 0
    case calendar
    case insights

    var title: String {
        switch self {
        case .capture: return "Capture every night"
        case .calendar: return "Connect the dots"
        case .insights: return "Spot your patterns"
        }
    }

    var message: String {
        switch self {
        case .capture:
            return "Save dreams while memory is fresh—mood, tags, and notes help you return to them later."
        case .calendar:
            return "Scan the calendar, favorite nights, and link repeating images to your personal symbol library."
        case .insights:
            return "Simple charts and hints highlight trends. Everything stays on your device."
        }
    }

    var symbolName: String {
        switch self {
        case .capture: return "moon.stars.fill"
        case .calendar: return "calendar.badge.clock"
        case .insights: return "chart.line.uptrend.xyaxis"
        }
    }
}

struct OnboardingView: View {
    @AppStorage(UserDefaultsKeys.onboardingCompleted) private var onboardingCompleted = false
    @State private var step: OnboardingStep = .capture

    var body: some View {
        ZStack {
            DreamScreenBackground()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") {
                        finishOnboarding()
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.dreamMystic)
                    .padding(.trailing, 6)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                TabView(selection: $step) {
                    ForEach(OnboardingStep.allCases, id: \.self) { page in
                        OnboardingPageContent(page: page)
                            .tag(page)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                VStack(spacing: 14) {
                    pageIndicators

                    HStack(spacing: 12) {
                        if step != .capture {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                                    if let prev = OnboardingStep(rawValue: step.rawValue - 1) {
                                        step = prev
                                    }
                                }
                            } label: {
                                Text("Back")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .foregroundColor(.dreamMystic)
                                    .dreamSecondaryButtonShape(cornerRadius: 14)
                            }
                            .buttonStyle(.plain)
                        }

                        Button {
                            advance()
                        } label: {
                            Text(step == .insights ? "Get started" : "Next")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .foregroundColor(Color.dreamBackground)
                                .dreamPrimaryButtonShape(cornerRadius: 14)
                                .dreamFloatingButtonShadow()
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 28)
                .padding(.top, 8)
            }
        }
    }

    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingStep.allCases, id: \.self) { page in
                Group {
                    if page == step {
                        Circle()
                            .fill(DreamDecor.buttonPrimary)
                            .shadow(color: Color.dreamLucid.opacity(0.35), radius: 6, x: 0, y: 2)
                    } else {
                        Circle()
                            .fill(Color.white.opacity(0.22))
                    }
                }
                .frame(width: page == step ? 10 : 7, height: page == step ? 10 : 7)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: step)
            }
        }
    }

    private func advance() {
        if step == .insights {
            finishOnboarding()
        } else if let next = OnboardingStep(rawValue: step.rawValue + 1) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                step = next
            }
        }
    }

    private func finishOnboarding() {
        onboardingCompleted = true
    }
}

private struct OnboardingPageContent: View {
    let page: OnboardingStep

    var body: some View {
        VStack(spacing: 22) {
            Spacer(minLength: 12)

            ZStack {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(DreamDecor.panelMist)
                    .frame(width: 132, height: 132)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36, style: .continuous)
                            .stroke(DreamDecor.borderGlow, lineWidth: 1)
                    )
                    .shadow(color: DreamDecor.shadowDeep.opacity(0.55), radius: 24, x: 0, y: 14)
                    .shadow(color: DreamDecor.glowLucid.opacity(0.2), radius: 18, x: 0, y: 8)

                Image(systemName: page.symbolName)
                    .font(.system(size: 54, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white.opacity(0.95), .dreamLucid, .dreamMystic],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: DreamDecor.shadowDeep.opacity(0.45), radius: 8, x: 0, y: 4)

                Text(page.message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.78))
                    .padding(.horizontal, 28)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 24)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    OnboardingView()
}
