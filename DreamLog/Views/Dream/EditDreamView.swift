//
//  EditDreamView.swift
//  DreamLog
//

import SwiftUI

struct EditDreamView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DreamLogViewModel

    @State private var draft: Dream

    @State private var tagsString: String
    @State private var charactersString: String
    @State private var locationsString: String
    @State private var selectedEmotions: Set<DreamEmotion>
    @State private var selectedSymbolIds: Set<UUID>

    init(viewModel: DreamLogViewModel, dream: Dream) {
        self.viewModel = viewModel
        _draft = State(initialValue: dream)
        _tagsString = State(initialValue: dream.tags.joined(separator: ", "))
        _charactersString = State(initialValue: dream.characters?.joined(separator: ", ") ?? "")
        _locationsString = State(initialValue: dream.locations?.joined(separator: ", ") ?? "")
        _selectedEmotions = State(initialValue: Set(dream.emotions))
        _selectedSymbolIds = State(initialValue: Set(dream.linkedSymbolIds))
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
                    DatePicker("Dream date", selection: $draft.date, displayedComponents: [.date, .hourAndMinute])
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    TextField("Title", text: $draft.title)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    ZStack(alignment: .topLeading) {
                        if draft.description.isEmpty {
                            Text("What happened…")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $draft.description)
                            .frame(minHeight: 100)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Message to yourself").foregroundColor(.dreamLucid)) {
                    ZStack(alignment: .topLeading) {
                        if (draft.messageToSelf ?? "").isEmpty {
                            Text("What might this dream be telling you? One honest line…")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: Binding(
                            get: { draft.messageToSelf ?? "" },
                            set: { draft.messageToSelf = $0.isEmpty ? nil : $0 }
                        ))
                        .frame(minHeight: 72)
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                    }
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Linked symbols").foregroundColor(.dreamLucid)) {
                    if viewModel.symbols.isEmpty {
                        Text("Add entries in the Symbols tab, then return here to link them.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("Toggle to link this dream with symbols from your library.")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.bottom, 4)
                        ForEach(viewModel.symbols) { symbol in
                            Toggle(isOn: symbolToggleBinding(symbol.id)) {
                                HStack {
                                    Image(systemName: "eye")
                                        .foregroundColor(.dreamMystic)
                                        .font(.caption)
                                    Text(symbol.name)
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(.dreamLucid)
                        }
                    }
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Details").foregroundColor(.gray)) {
                    Picker("Dream type", selection: $draft.type) {
                        ForEach(DreamType.allCases, id: \.self) { t in
                            Label(t.rawValue, systemImage: t.icon).tag(t)
                        }
                    }
                    .tint(.dreamLucid)
                    Picker("Clarity", selection: $draft.intensity) {
                        ForEach(DreamIntensity.allCases, id: \.self) { v in
                            Text(v.description).tag(v)
                        }
                    }
                    .tint(.dreamLucid)
                    HStack {
                        Text("Duration (min)")
                        Spacer()
                        TextField("", value: $draft.duration, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .foregroundColor(.white)
                            .tint(.dreamLucid)
                    }
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Emotions").foregroundColor(.gray)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(DreamEmotion.allCases, id: \.self) { emotion in
                                Button {
                                    if selectedEmotions.contains(emotion) {
                                        selectedEmotions.remove(emotion)
                                    } else {
                                        selectedEmotions.insert(emotion)
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: emotion.icon)
                                        Text(emotion.rawValue)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(selectedEmotions.contains(emotion) ? Color.dreamLucid : Color.dreamMystic.opacity(0.2))
                                    .foregroundColor(selectedEmotions.contains(emotion) ? Color.dreamBackground : Color.dreamLucid)
                                    .cornerRadius(16)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Tags").foregroundColor(.gray)) {
                    TextField("Comma-separated tags", text: $tagsString)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Cast & places").foregroundColor(.gray)) {
                    TextField("Characters (comma-separated)", text: $charactersString)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    TextField("Locations (comma-separated)", text: $locationsString)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Notes").foregroundColor(.gray)) {
                    ZStack(alignment: .topLeading) {
                        if (draft.notes ?? "").isEmpty {
                            Text("Private notes…")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: Binding(
                            get: { draft.notes ?? "" },
                            set: { draft.notes = $0.isEmpty ? nil : $0 }
                        ))
                        .frame(minHeight: 80)
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                    }
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section {
                    Toggle("Mark as favorite", isOn: $draft.isFavorite)
                        .tint(.dreamLucid)
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Edit")
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
                        .disabled(draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            }
        }
        .tint(.dreamLucid)
    }

    private func symbolToggleBinding(_ id: UUID) -> Binding<Bool> {
        Binding(
            get: { selectedSymbolIds.contains(id) },
            set: { on in
                if on { selectedSymbolIds.insert(id) }
                else { selectedSymbolIds.remove(id) }
            }
        )
    }

    private func save() {
        let chars = splitList(charactersString)
        let locs = splitList(locationsString)
        draft.tags = tags
        draft.emotions = Array(selectedEmotions)
        draft.characters = chars.isEmpty ? nil : chars
        draft.locations = locs.isEmpty ? nil : locs
        draft.linkedSymbolIds = Array(selectedSymbolIds)
        viewModel.updateDream(draft)
        dismiss()
    }

    private func splitList(_ s: String) -> [String] {
        s.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
