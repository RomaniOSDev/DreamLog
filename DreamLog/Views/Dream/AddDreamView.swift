//
//  AddDreamView.swift
//  DreamLog
//

import SwiftUI

struct AddDreamView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DreamLogViewModel

    var defaultDate: Date = Date()

    @State private var dreamDate: Date = Date()
    @State private var titleText = ""
    @State private var descriptionText = ""
    @State private var type: DreamType = .ordinary
    @State private var intensity: DreamIntensity = .medium
    @State private var selectedEmotions: Set<DreamEmotion> = []
    @State private var tagsString = ""
    @State private var charactersString = ""
    @State private var locationsString = ""
    @State private var notes = ""
    @State private var messageToSelf = ""
    @State private var selectedSymbolIds: Set<UUID> = []
    @State private var duration: Int?
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
                    DatePicker("Dream date", selection: $dreamDate, displayedComponents: [.date, .hourAndMinute])
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    TextField("Title", text: $titleText)
                        .foregroundColor(.white)
                        .tint(.dreamLucid)
                    ZStack(alignment: .topLeading) {
                        if descriptionText.isEmpty {
                            Text("What happened…")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $descriptionText)
                            .frame(minHeight: 100)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section(header: Text("Message to yourself").foregroundColor(.dreamLucid)) {
                    ZStack(alignment: .topLeading) {
                        if messageToSelf.isEmpty {
                            Text("What might this dream be telling you? One honest line…")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $messageToSelf)
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
                        Text("Tap a row to link or unlink. Linked items use your symbol library.")
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
                    Picker("Dream type", selection: $type) {
                        ForEach(DreamType.allCases, id: \.self) { t in
                            Label(t.rawValue, systemImage: t.icon).tag(t)
                        }
                    }
                    .tint(.dreamLucid)
                    Picker("Clarity", selection: $intensity) {
                        ForEach(DreamIntensity.allCases, id: \.self) { v in
                            Text(v.description).tag(v)
                        }
                    }
                    .tint(.dreamLucid)
                    HStack {
                        Text("Duration (min)")
                        Spacer()
                        TextField("", value: $duration, format: .number)
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
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.dreamMystic.opacity(0.2))
                                        .foregroundColor(.dreamLucid)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
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
                        if notes.isEmpty {
                            Text("Private notes…")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $notes)
                            .frame(minHeight: 80)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))

                Section {
                    Toggle("Mark as favorite", isOn: $isFavorite)
                        .tint(.dreamLucid)
                }
                .listRowBackground(Color.dreamMystic.opacity(0.15))
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("New dream")
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
                        .disabled(titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                dreamDate = defaultDate
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
        let dream = Dream(
            id: UUID(),
            date: dreamDate,
            title: titleText.trimmingCharacters(in: .whitespacesAndNewlines),
            description: descriptionText.trimmingCharacters(in: .whitespacesAndNewlines),
            type: type,
            intensity: intensity,
            emotions: Array(selectedEmotions),
            tags: tags,
            characters: chars.isEmpty ? nil : chars,
            locations: locs.isEmpty ? nil : locs,
            duration: duration,
            isFavorite: isFavorite,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes.trimmingCharacters(in: .whitespacesAndNewlines),
            messageToSelf: messageToSelf.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? nil : messageToSelf.trimmingCharacters(in: .whitespacesAndNewlines),
            linkedSymbolIds: Array(selectedSymbolIds),
            createdAt: Date()
        )
        viewModel.addDream(dream)
        dismiss()
    }

    private func splitList(_ s: String) -> [String] {
        s.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
