//
//  HomeView.swift
//  DreamLog
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: DreamLogViewModel
    @Binding var selectedTab: Int

    @State private var showAddDream = false
    @State private var selectedDream: Dream?
    @State private var dreamToEdit: Dream?

    private var recentDreams: [Dream] {
        let todayIds = Set(todaysDreams.map(\.id))
        return Array(
            viewModel.dreams
                .filter { !todayIds.contains($0.id) }
                .sorted { $0.date > $1.date }
                .prefix(6)
        )
    }

    private var todaysDreams: [Dream] {
        viewModel.dreamsOnDate(Date())
    }

    private var todayLunar: MoonPhaseHelper.LunarMark {
        MoonPhaseHelper.lunarMark(forCalendarDay: Date())
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    heroSection

                    statsScroller

                    quickActionsRow

                    exploreGrid

                    if !todaysDreams.isEmpty {
                        sectionHeader("Today")
                        VStack(spacing: 10) {
                            ForEach(todaysDreams) { dream in
                                dreamRowButton(dream)
                            }
                        }
                    } else {
                        todayEmptyCard
                    }

                    sectionHeader("Recent dreams")
                    if recentDreams.isEmpty {
                        recentEmptyCard
                    } else {
                        VStack(spacing: 10) {
                            ForEach(recentDreams) { dream in
                                dreamRowButton(dream)
                            }
                        }
                    }

                    Color.clear.frame(height: 88)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .dreamScreenBackdrop()

            Button {
                showAddDream = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 54))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color.dreamLucid)
            }
            .dreamFloatingButtonShadow()
            .padding(20)
            .accessibilityLabel("Log a dream")
        }
        .sheet(isPresented: $showAddDream) {
            AddDreamView(viewModel: viewModel, defaultDate: Date())
        }
        .sheet(item: $selectedDream) { dream in
            DreamDetailView(
                dream: dream,
                viewModel: viewModel,
                onEdit: { dreamToEdit = dream }
            )
        }
        .sheet(item: $dreamToEdit) { dream in
            EditDreamView(viewModel: viewModel, dream: dream)
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(MoonPhaseHelper.greeting())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color.white.opacity(0.82)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text(formattedTodaySubtitle())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(spacing: 6) {
                    LunarPhaseGlyph(mark: todayLunar)
                        .frame(width: 22, height: 22)
                    Text(MoonPhaseHelper.label())
                        .font(.caption2)
                        .foregroundColor(.dreamLucid)
                        .multilineTextAlignment(.center)
                }
                .padding(12)
                .dreamCardChrome(cornerRadius: 16)
            }

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewModel.streakDays)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.dreamLucid)
                    Text("night streak")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewModel.monthlyCount)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("dreams this month")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .dreamDeepPanel(cornerRadius: 20)
        }
    }

    private var statsScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Total",
                    value: "\(viewModel.totalDreams)",
                    icon: "moon.stars",
                    color: .dreamLucid,
                    cardColor: .dreamMystic.opacity(0.22)
                )
                .frame(width: 132, alignment: .leading)
                StatCard(
                    title: "Lucid",
                    value: "\(viewModel.lucidCount)",
                    icon: "sparkles",
                    color: .dreamLucid,
                    cardColor: .dreamMystic.opacity(0.22)
                )
                .frame(width: 132, alignment: .leading)
                StatCard(
                    title: "Symbols",
                    value: "\(viewModel.symbols.count)",
                    icon: "book.closed",
                    color: .dreamMystic,
                    cardColor: .dreamMystic.opacity(0.22)
                )
                .frame(width: 132, alignment: .leading)
                StatCard(
                    title: "Recall est.",
                    value: String(format: "%.0f%%", viewModel.recallRate),
                    icon: "brain",
                    color: .dreamLucid,
                    cardColor: .dreamMystic.opacity(0.22)
                )
                .frame(width: 132, alignment: .leading)
            }
            .padding(.vertical, 4)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private var quickActionsRow: some View {
        HStack(spacing: 12) {
            Button {
                showAddDream = true
            } label: {
                Label("Log a dream", systemImage: "moon.stars.fill")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(Color.dreamBackground)
                    .dreamPrimaryButtonShape(cornerRadius: 14)
            }
            Button {
                selectedTab = 1
            } label: {
                Label("Calendar", systemImage: "calendar")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(.dreamLucid)
                    .dreamSecondaryButtonShape(cornerRadius: 14)
            }
        }
    }

    private var exploreGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Explore")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                exploreTile(title: "Symbols", icon: "book.closed", tab: 2)
                exploreTile(title: "Patterns", icon: "chart.line.uptrend.xyaxis", tab: 3)
                exploreTile(title: "Statistics", icon: "chart.bar.fill", tab: 4)
                exploreTile(title: "All dreams", icon: "square.grid.2x2", tab: 1)
            }
        }
    }

    private func exploreTile(title: String, icon: String, tab: Int) -> some View {
        Button {
            selectedTab = tab
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.dreamLucid)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(14)
            .dreamCardChrome(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.75)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }

    private var todayEmptyCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nothing logged for today yet.")
                .font(.subheadline)
                .foregroundColor(.gray)
            Button {
                showAddDream = true
            } label: {
                Text("Capture tonight’s dream")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.dreamLucid)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .dreamCardChrome(cornerRadius: 16)
    }

    private var recentEmptyCard: some View {
        Text("When you log dreams, they will appear here for quick access.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .dreamCardChrome(cornerRadius: 16)
    }

    private func dreamRowButton(_ dream: Dream) -> some View {
        Button {
            selectedDream = dream
        } label: {
            CompactDreamRow(dream: dream)
        }
        .buttonStyle(.plain)
    }

    private func formattedTodaySubtitle() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        f.locale = Locale(identifier: "en_US")
        return f.string(from: Date())
    }
}
