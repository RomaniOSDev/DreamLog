//
//  AddSymbolView.swift
//  DreamLog
//

import SwiftUI

struct AddSymbolView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DreamLogViewModel

    @State private var name = ""
    @State private var meaning = ""
    @State private var tagsString = ""
    @State private var isFavorite = false

    private var tags: [String] {
        tagsString
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        ZStack {
            DreamScreenBackground()
            NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    ZStack(alignment: .topLeading) {
                        if meaning.isEmpty {
                            Text("Meaning or interpretation")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $meaning)
                            .frame(minHeight: 100)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                    TextField("Tags (comma-separated)", text: $tagsString)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    Toggle("Mark as favorite", isOn: $isFavorite)
                        .tint(.dreamLucid)
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("New symbol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.dreamMystic)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .foregroundColor(.dreamLucid)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            }
        }
        .tint(.dreamLucid)
    }

    private func save() {
        let symbol = DreamSymbol(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            meaning: meaning.trimmingCharacters(in: .whitespacesAndNewlines),
            tags: tags,
            isFavorite: isFavorite
        )
        viewModel.addSymbol(symbol)
        dismiss()
    }
}
