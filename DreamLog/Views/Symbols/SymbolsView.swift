//
//  SymbolsView.swift
//  DreamLog
//

import SwiftUI

struct SymbolsView: View {
    @ObservedObject var viewModel: DreamLogViewModel
    @State private var showAddSymbolSheet = false
    @State private var selectedSymbol: DreamSymbol?
    @State private var symbolToEdit: DreamSymbol?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Dream symbols")
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
                        .padding(.horizontal, 16)

                    ForEach(viewModel.symbols) { symbol in
                        SymbolCard(symbol: symbol)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedSymbol = symbol
                            }
                            .contextMenu {
                                Button {
                                    selectedSymbol = symbol
                                } label: {
                                    Label("Open", systemImage: "eye")
                                }
                                Button {
                                    symbolToEdit = symbol
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                Button {
                                    viewModel.toggleFavoriteSymbol(symbol)
                                } label: {
                                    Label("Favorite", systemImage: "star")
                                }
                                Button(role: .destructive) {
                                    viewModel.deleteSymbol(symbol)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .padding(.horizontal, 16)
                    }
                    Button("Add symbol") {
                        showAddSymbolSheet = true
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color.dreamBackground)
                    .dreamPrimaryButtonShape(cornerRadius: 14)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
            .dreamScreenBackdrop()
            .sheet(isPresented: $showAddSymbolSheet) {
                AddSymbolView(viewModel: viewModel)
            }
            .sheet(item: $selectedSymbol) { symbol in
                SymbolDetailView(
                    symbol: symbol,
                    viewModel: viewModel,
                    onEdit: {
                        symbolToEdit = symbol
                    }
                )
            }
            .sheet(item: $symbolToEdit) { symbol in
                EditSymbolView(viewModel: viewModel, symbol: symbol)
            }
        }
        .background(Color.clear)
    }
}
