//
//  SettingsView.swift
//  DreamLog
//

import StoreKit
import SwiftUI
import UIKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            DreamScreenBackground()
            NavigationStack {
                List {
                    Section {
                        Button {
                            rateApp()
                        } label: {
                            Label("Rate us", systemImage: "star.fill")
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.dreamMystic.opacity(0.15))

                        Button {
                            openExternalLink(.privacyPolicy)
                        } label: {
                            Label("Privacy Policy", systemImage: "hand.raised.fill")
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.dreamMystic.opacity(0.15))

                        Button {
                            openExternalLink(.termsOfUse)
                        } label: {
                            Label("Terms of Use", systemImage: "doc.text.fill")
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.dreamMystic.opacity(0.15))
                    } header: {
                        Text("About")
                            .foregroundColor(.dreamLucid)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }

    private func openExternalLink(_ link: AppExternalURL) {
        if let url = URL(string: link.rawValue) {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

#Preview {
    SettingsView()
}
