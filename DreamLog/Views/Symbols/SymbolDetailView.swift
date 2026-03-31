//
//  SymbolDetailView.swift
//  DreamLog
//

import SwiftUI

struct SymbolDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let symbol: DreamSymbol
    @ObservedObject var viewModel: DreamLogViewModel
    var onEdit: () -> Void

    @State private var showDeleteConfirmation = false
    @State private var linkedDream: Dream?

    private var dreamsWithSymbol: [Dream] {
        viewModel.dreams(linkingSymbolId: symbol.id)
    }

    var body: some View {
        ZStack {
            DreamScreenBackground()
            NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        Image(systemName: "eye")
                            .font(.largeTitle)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.dreamMystic, .dreamLucid.opacity(0.85)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: DreamDecor.glowLucid.opacity(0.5), radius: 8, x: 0, y: 4)
                        Text(symbol.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(color: DreamDecor.shadowDeep.opacity(0.6), radius: 6, x: 0, y: 3)
                        Spacer()
                        if symbol.isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundStyle(DreamDecor.buttonPrimary)
                                .shadow(color: Color.dreamLucid.opacity(0.45), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Meaning")
                            .font(.headline)
                            .foregroundColor(.dreamLucid)
                        Text(symbol.meaning)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dreamInsetPanel(cornerRadius: 14)
                    }
                    .padding(.horizontal)

                    if !symbol.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.headline)
                                .foregroundColor(.dreamLucid)
                            FlowTagWrap(tags: symbol.tags)
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Appears in dreams")
                            .font(.headline)
                            .foregroundColor(.dreamLucid)
                        if dreamsWithSymbol.isEmpty {
                            Text("Nothing linked yet. Edit a dream and toggle this symbol under \"Linked symbols\".")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .dreamInsetPanel(cornerRadius: 14)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(dreamsWithSymbol) { dream in
                                    Button {
                                        linkedDream = dream
                                    } label: {
                                        HStack {
                                            Text(dream.title)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Text(formattedShortDate(dream.date))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .dreamInsetPanel(cornerRadius: 12)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    HStack(spacing: 12) {
                        Button("Edit") {
                            dismiss()
                            DispatchQueue.main.async {
                                onEdit()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color.dreamBackground)
                        .fontWeight(.semibold)
                        .dreamPrimaryButtonShape(cornerRadius: 14)
                        .dreamFloatingButtonShadow()

                        Button("Delete") {
                            showDeleteConfirmation = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.dreamMystic)
                        .fontWeight(.medium)
                        .dreamSecondaryButtonShape(cornerRadius: 14)
                    }
                    .padding()
                }
                .padding(.vertical)
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.dreamMystic)
                }
            }
            .alert("Delete this symbol?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.deleteSymbol(symbol)
                    dismiss()
                }
            } message: {
                Text("This cannot be undone.")
            }
            .sheet(item: $linkedDream) { dream in
                DreamDetailView(
                    dream: dream,
                    viewModel: viewModel,
                    onEdit: {
                        linkedDream = nil
                    }
                )
            }
            }
        }
        .tint(.dreamLucid)
    }
}

/// Simple wrapping tag row for detail (no inner ScrollView).
private struct FlowTagWrap: View {
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let rows = tagRows(tags: tags, maxPerRow: 4)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(DreamDecor.panelMist)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(DreamDecor.borderGlow.opacity(0.7), lineWidth: 1)
                            )
                            .foregroundColor(.dreamMystic)
                            .shadow(color: DreamDecor.shadowDeep.opacity(0.35), radius: 4, x: 0, y: 2)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func tagRows(tags: [String], maxPerRow: Int) -> [[String]] {
        stride(from: 0, to: tags.count, by: maxPerRow).map {
            Array(tags[$0..<min($0 + maxPerRow, tags.count)])
        }
    }
}
