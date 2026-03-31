//
//  RootView.swift
//  DreamLog
//

import SwiftUI

struct RootView: View {
    @AppStorage(UserDefaultsKeys.onboardingCompleted) private var onboardingCompleted = false

    var body: some View {
        Group {
            if onboardingCompleted {
                ContentView()
            } else {
                OnboardingView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootView()
}
