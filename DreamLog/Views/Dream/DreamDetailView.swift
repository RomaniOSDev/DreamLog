//
//  DreamDetailView.swift
//  DreamLog
//

import SwiftUI

struct DreamDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let dream: Dream
    @ObservedObject var viewModel: DreamLogViewModel
    var onEdit: () -> Void

    @State private var showDeleteConfirmation = false

    private var linkedSymbolModels: [DreamSymbol] {
        dream.linkedSymbolIds.compactMap { id in
            viewModel.symbols.first { $0.id == id }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: dream.type.icon)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [dream.type.color, dream.type.color.opacity(0.75)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .font(.largeTitle)
                            Text(dream.title)
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, Color.white.opacity(0.88)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Spacer()
                            if dream.isFavorite {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.dreamLucid)
                            }
                        }
                        Text(formattedDate(dream.date))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Text(dream.type.rawValue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(dream.type.color.opacity(0.2))
                                .foregroundColor(dream.type.color)
                                .cornerRadius(8)
                            Text("Clarity: \(dream.intensity.rawValue)/5")
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.dreamLucid.opacity(0.2))
                                .foregroundColor(.dreamLucid)
                                .cornerRadius(8)
                            if let duration = dream.duration {
                                Text("\(duration) min")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.dreamMystic.opacity(0.2))
                                    .foregroundColor(.dreamMystic)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Story")
                            .font(.headline)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        Text(dream.description)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(14)
                    .dreamInsetPanel(cornerRadius: 16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Message to yourself")
                            .font(.headline)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        let message = dream.messageToSelf?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                        if message.isEmpty {
                            Text("Not set yet — tap Edit below to add a short line about what this dream might mean for you.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(message)
                                .font(.body)
                                .italic()
                                .foregroundColor(.white.opacity(0.95))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(14)
                    .dreamInsetPanel(cornerRadius: 16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Linked symbols")
                            .font(.headline)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        if linkedSymbolModels.isEmpty {
                            Text("None linked — open Edit and toggle symbols from your library.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(linkedSymbolModels) { symbol in
                                    HStack {
                                        Image(systemName: "eye")
                                            .foregroundColor(.dreamMystic)
                                            .font(.caption)
                                        Text(symbol.name)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color.dreamMystic.opacity(0.28))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(Color.dreamMystic.opacity(0.45), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                    }
                    .padding(14)
                    .dreamInsetPanel(cornerRadius: 16)
                    .padding(.horizontal)

                    if !dream.emotions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Emotions")
                                .font(.headline)
                                .foregroundColor(.dreamLucid)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(dream.emotions, id: \.self) { emotion in
                                        HStack {
                                            Image(systemName: emotion.icon)
                                            Text(emotion.rawValue)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.dreamMystic.opacity(0.2))
                                        .foregroundColor(.dreamLucid)
                                        .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if let characters = dream.characters, !characters.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Characters")
                                .font(.headline)
                                .foregroundColor(.dreamLucid)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(characters, id: \.self) { character in
                                        Text(character)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.dreamMystic.opacity(0.2))
                                            .foregroundColor(.white)
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if let locations = dream.locations, !locations.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Places")
                                .font(.headline)
                                .foregroundColor(.dreamLucid)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(locations, id: \.self) { location in
                                        Text(location)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.dreamMystic.opacity(0.2))
                                            .foregroundColor(.white)
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if !dream.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.headline)
                                .foregroundColor(.dreamLucid)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(dream.tags, id: \.self) { tag in
                                        Text("#\(tag)")
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.dreamMystic.opacity(0.2))
                                            .foregroundColor(.dreamMystic)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if let notes = dream.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Text(notes)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(14)
                        .dreamInsetPanel(cornerRadius: 16)
                        .padding(.horizontal)
                    }

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
                        .dreamPrimaryButtonShape(cornerRadius: 12)

                        Button("Delete") {
                            showDeleteConfirmation = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.dreamMystic)
                        .dreamSecondaryButtonShape(cornerRadius: 12)
                    }
                    .padding()
                }
                .padding(.vertical)
            }
            .dreamScreenBackdrop()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.dreamMystic)
                }
            }
            .alert("Delete this dream?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.deleteDream(dream)
                    dismiss()
                }
            } message: {
                Text("This cannot be undone.")
            }
        }
        .tint(.dreamLucid)
    }
}
