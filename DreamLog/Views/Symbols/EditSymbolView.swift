//
//  EditSymbolView.swift
//  DreamLog
//

import SwiftUI

struct EditSymbolView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DreamLogViewModel

    @State private var draft: DreamSymbol
    @State private var tagsString: String

    init(viewModel: DreamLogViewModel, symbol: DreamSymbol) {
        self.viewModel = viewModel
        _draft = State(initialValue: symbol)
        _tagsString = State(initialValue: symbol.tags.joined(separator: ", "))
    }

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
                    TextField("Name", text: $draft.name)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    ZStack(alignment: .topLeading) {
                        if draft.meaning.isEmpty {
                            Text("Meaning or interpretation")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $draft.meaning)
                            .frame(minHeight: 100)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                    TextField("Tags (comma-separated)", text: $tagsString)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    Toggle("Mark as favorite", isOn: $draft.isFavorite)
                        .tint(.dreamLucid)
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Edit symbol")
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
                        .disabled(draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            }
        }
        .tint(.dreamLucid)
    }

    private func save() {
        draft.tags = tags
        draft.name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        draft.meaning = draft.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.updateSymbol(draft)
        dismiss()
    }
}
