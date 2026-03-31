//
//  PatternsView.swift
//  DreamLog
//

import SwiftUI

struct PatternsView: View {
    @ObservedObject var viewModel: DreamLogViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    Text("Patterns")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.75)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    if viewModel.patterns.isEmpty {
                        Text("Tags from new dreams will surface recurring motifs here.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dreamCardChrome(cornerRadius: 18)
                            .padding(.horizontal)
                    }

                    ForEach(viewModel.patterns) { pattern in
                        PatternCard(pattern: pattern)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)
            }
            .dreamScreenBackdrop()
        }
        .background(Color.clear)
    }
}
