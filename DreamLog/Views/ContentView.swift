//
//  ContentView.swift
//  DreamLog
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DreamLogViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            CalendarView(viewModel: viewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)

            SymbolsView(viewModel: viewModel)
                .tabItem {
                    Label("Symbols", systemImage: "book.closed")
                }
                .tag(2)

            PatternsView(viewModel: viewModel)
                .tabItem {
                    Label("Patterns", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)

            StatsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(4)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(5)
        }
        .onAppear {
            viewModel.loadFromUserDefaults()
        }
        .tint(.dreamLucid)
    }
}

#Preview {
    ContentView()
}
